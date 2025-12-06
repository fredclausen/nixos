{
  lib,
  agentNodes,
  ...
}:
let
  agentHosts = agentNodes;
in
{
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
    "prometheus/alert-rules.yaml" = {
      source = ./alert-rules/alert-rules.yaml;
      user = "prometheus";
      group = "prometheus";
      mode = "0444";
    };
  };

  networking.firewall.allowedTCPPorts = [
    9090 # Prometheus
    9093 # Alertmanager
  ];

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
          scheme = "http";
          static_configs = [
            { targets = [ "127.0.0.1:9093" ]; }
          ];
        }
      ];

      ruleFiles = [
        ./alert-rules/alert-rules.yaml
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
  };
}
