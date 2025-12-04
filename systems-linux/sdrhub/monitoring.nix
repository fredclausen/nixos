{
  lib,
  pkgs,
  ...
}:

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

  environment.etc."grafana/provisioning/dashboards/system/node-exporter-full.json" = {
    source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/rfrail3/grafana-dashboards/master/prometheus/node-exporter-full.json";
      sha256 = "sha256-lOpPVIW4Rih8/5zWnjC3K0kKgK5Jc1vQgCgj4CVkYP4=";
    };

    user = "grafana";
    group = "grafana";
    mode = "0444";
  };

  #######################################
  # Prometheus
  #######################################
  services = {
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
          static_configs = [
            { targets = [ "127.0.0.1:9093" ]; }
          ];
        }
      ];

      ruleFiles = [ ];

      exporters.node = {
        enable = true;
        openFirewall = true;
        listenAddress = "0.0.0.0";
        port = 9100;
      };

      scrapeConfigs = [
        {
          job_name = "node";
          static_configs = [
            { targets = [ "127.0.0.1:9100" ]; }
          ];
        }
        {
          job_name = "cadvisor";
          static_configs = [
            { targets = [ "127.0.0.1:4567" ]; }
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
    };

    #######################################
    # Alertmanager
    #######################################
    prometheus.alertmanager = {
      enable = true;

      listenAddress = "0.0.0.0";
      port = 9093;

      configuration = {
        global = {
          resolve_timeout = "5m";
        };

        route = {
          receiver = "null";
        };

        receivers = [
          {
            name = "null";
          }
        ];
      };
    };

    #######################################
    # Pushgateway
    #######################################
    prometheus.pushgateway = {
      enable = true;

      # If you want bind to localhost-only:
      extraFlags = [
        "--web.listen-address=127.0.0.1:9091"
      ];
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
            ];
          };
        };
      };

      dataDir = "/var/lib/grafana";
    };

    cadvisor = {
      enable = true;
      port = 4567;
    };
  };

  #######################################
  # Firewall
  #######################################
  networking.firewall.allowedTCPPorts = [
    9090 # Prometheus
    9093 # Alertmanager
    3333 # Grafana
  ];
}
