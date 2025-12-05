{
  lib,
  pkgs,
  agentNodes,
  ...
}:
let
  agentHosts = agentNodes;
in
{
  #######################################
  # SOPS Secret
  #######################################
  sops.secrets."monitoring/grafana_pw" = {
    owner = "grafana";
  };

  systemd.services.prometheus.serviceConfig = {
    WorkingDirectory = lib.mkForce "/opt/monitoring/prometheus";
  };

  system.activationScripts.prometheus_activation = {
    text = ''
      # Ensure directory exists (does not touch contents if already there)
      install -d -m0755 -o fred -g users /opt/monitoring/prometheus
    '';
    deps = [ ];
  };

  environment.etc = {
    "grafana/provisioning/dashboards/system/node-exporter-full.json" = {
      source = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/rfrail3/grafana-dashboards/master/prometheus/node-exporter-full.json";
        sha256 = "sha256-lOpPVIW4Rih8/5zWnjC3K0kKgK5Jc1vQgCgj4CVkYP4=`";
      };
      user = "grafana";
      group = "grafana";
      mode = "0444";
    };

    "grafana/provisioning/dashboards/containers/dashboard-container-overview.json" = {
      user = "grafana";
      group = "grafana";
      mode = "0444";

      source = ./container.json;
    };

    "prometheus/alert-rules.yaml" = {
      source = ./alert-rules.yaml;
      user = "prometheus";
      group = "prometheus";
      mode = "0444";
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/loki 0750 loki loki -"
  ];

  #######################################
  # Prometheus
  #######################################
  services = {
    loki = {
      enable = true;

      configuration = {
        server = {
          http_listen_address = "0.0.0.0";
          http_listen_port = 5678;
        };

        auth_enabled = false;

        common = {
          replication_factor = 1;
          path_prefix = "/var/lib/loki";

          ring = {
            kvstore.store = "inmemory";
            instance_addr = "127.0.0.1";
          };
        };

        #
        # Loki 3.x TSDB schema
        #
        schema_config = {
          configs = [
            {
              from = "2024-01-01";
              store = "tsdb";
              object_store = "filesystem";
              schema = "v13";
              index = {
                prefix = "index_";
                period = "24h";
              };
            }
          ];
        };

        #
        # Loki 3.x retention lives here
        #
        limits_config = {
          retention_period = "30d";
        };

        #
        # Loki 3.x compactor settings
        #
        compactor = {
          working_directory = "/var/lib/loki/compactor";

          # shared_store = "filesystem";

          compaction_interval = "10m";
          retention_enabled = true;
          retention_delete_delay = "2h";
          delete_request_store = "filesystem";
        };

        storage_config.filesystem.directory = "/var/lib/loki/chunks";

        analytics.reporting_enabled = false;
      };
    };

    prometheus = {
      enable = true;

      # Explicit listen address
      listenAddress = "0.0.0.0";
      port = 9090;

      # Prometheus now requires extraFlags for TSDB paths
      extraFlags = [
        "--storage.tsdb.retention.time=30d"
      ];

      globalConfig = {
        scrape_interval = "15s";
        evaluation_interval = "15s";
      };

      alertmanagers = [
        {
          scheme = "http";
          static_configs = [
            { targets = [ "127.0.0.1:9093" ]; }
          ];
        }
      ];

      ruleFiles = [
        ./alert-rules.yaml
      ];

      scrapeConfigs = [
        {
          job_name = "node";
          static_configs =
            (map (h: {
              targets = [ "${h}.local:9100" ];
              labels = {
                hostname = h;
                role = "agent";
                exporter = "node";
              };
            }) agentHosts)
            ++ [
              {
                targets = [ "sdrhub.local:9100" ];
                labels = {
                  hostname = "sdrhub";
                  role = "master";
                  exporter = "node";
                };
              }
            ];
        }

        {
          job_name = "cadvisor";
          static_configs =
            (map (h: {
              targets = [ "${h}.local:4567" ];
              labels = {
                hostname = h;
                role = "agent";
                exporter = "cadvisor";
              };
            }) agentHosts)
            ++ [
              {
                targets = [ "sdrhub.local:4567" ];
                labels = {
                  hostname = "sdrhub";
                  role = "master";
                  exporter = "cadvisor";
                };
              }
            ];
        }

        {
          job_name = "prometheus";
          static_configs = [
            { targets = [ "127.0.0.1:9090" ]; }
          ];
        }
        {
          job_name = "pushgateway";
          honor_labels = true;
          static_configs = [
            { targets = [ "127.0.0.1:9091" ]; }
          ];
        }
      ];

      alertmanager-ntfy = {
        enable = true;
        settings = {
          http = {
            addr = "127.0.0.1:8000";
          };
          ntfy = {
            baseurl = "https://ntfy.sh";
            notification = {
              topic = "fred-sdrhub-alerts";
              priority = ''
                status == "firing" ? "high" : "default"
              '';
              tags = [
                {
                  tag = "+1";
                  condition = ''status == "resolved"'';
                }
                {
                  tag = "rotating_light";
                  condition = ''status == "firing"'';
                }
              ];
              templates = {
                title = ''{{ if eq .Status "resolved" }}Resolved: {{ end }}{{ index .Annotations "summary" }}'';
                description = ''{{ index .Annotations "description" }}'';
              };
            };
          };
        };
      };

      #######################################
      # Alertmanager
      #######################################
      alertmanager = {
        enable = true;

        listenAddress = "0.0.0.0";
        port = 9093;

        configuration = {
          global = {
            resolve_timeout = "5m";
          };

          route = {
            receiver = "ntfy";
          };

          receivers = [
            {
              name = "ntfy";

              webhook_configs = [
                {
                  url = "http://127.0.0.1:8000/hook";
                  send_resolved = true;
                }
              ];
            }
          ];
        };
      };

      #######################################
      # Pushgateway
      #######################################
      pushgateway = {
        enable = true;

        # If you want bind to localhost-only:
        extraFlags = [
          "--web.listen-address=127.0.0.1:9091"
        ];
      };
    };

    #######################################
    # Grafana
    #######################################
    grafana = {
      enable = true;

      settings = {
        server = {
          http_port = 3333;
          http_addr = "0.0.0.0";
        };

        security = {
          admin_user = "admin";
          admin_password = "$__file{/run/secrets/monitoring/grafana_pw}";
        };
      };

      provision = {
        enable = true;

        datasources = {
          settings = {
            datasources = [
              {
                name = "Prometheus";
                type = "prometheus";
                url = "http://127.0.0.1:9090";
                access = "proxy";
                isDefault = true;
              }

              {
                name = "Loki";
                type = "loki";
                access = "proxy";
                url = "http://localhost:3100";
                isDefault = false;
              }
            ];
          };
        };

        dashboards = {
          settings = {
            apiVersion = 1;

            providers = [
              {
                name = "node-exporter";
                orgId = 1;
                folder = "System";
                type = "file";
                disableDeletion = true;
                updateIntervalSeconds = 60;

                options = {
                  path = "/etc/grafana/provisioning/dashboards/system";
                };
              }

              {
                name = "cadvisor";
                orgId = 1;
                folder = "Container";
                type = "file";
                disableDeletion = true;
                updateIntervalSeconds = 60;

                options = {
                  path = "/etc/grafana/provisioning/dashboards/containers";
                };
              }
            ];
          };
        };
      };

      dataDir = "/var/lib/grafana";
    };
  };

  #######################################
  # Firewall
  #######################################
  networking.firewall.allowedTCPPorts = [
    9090 # Prometheus
    9093 # Alertmanager
    3333 # Grafana
    5678 # Loki
  ];
}
