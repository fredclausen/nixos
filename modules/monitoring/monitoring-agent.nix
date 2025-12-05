{ config, ... }:
{
  systemd.tmpfiles.rules = [
    "d /var/lib/promtail 0755 promtail promtail -"
  ];

  users.users.promtail.extraGroups = [ "docker" ];

  #########################################################
  # Node Exporter (runs on every node)
  #########################################################
  services = {
    promtail = {
      enable = true;
      configuration = {
        server = {
          http_listen_port = 9080;
          grpc_listen_port = 0;
        };
        positions = {
          filename = "/var/lib/promtail/positions.yaml";
        };
        clients = [
          {
            url = "http://192.168.31.20:5678/loki/api/v1/push";
            tenant_id = "default";
          }
        ];
        scrape_configs = [
          # System journal logs
          {
            job_name = "journal";
            journal = {
              path = "/var/log/journal";
              labels = {
                job = "journal";
                hostname = "${config.networking.hostName}";
                host = "${config.networking.hostName}";
              };
            };
            relabel_configs = [
              {
                source_labels = [ "__journal__systemd_unit" ];
                target_label = "unit";
              }
              {
                source_labels = [ "__journal__container_name" ];
                target_label = "container";
              }
              {
                source_labels = [ "__journal__container_id" ];
                target_label = "container_id";
              }
            ];
          }
        ];
      };
    };

    prometheus.exporters.node = {
      enable = true;
      openFirewall = true;
      listenAddress = "0.0.0.0";
      port = 9100;
    };

    #########################################################
    # cAdvisor
    #########################################################
    cadvisor = {
      enable = true;
      listenAddress = "0.0.0.0";
      port = 4567;
    };
  };

  #########################################################
  # (Optional future expansions)
  # - systemd exporter
  # - docker exporter
  # - github-runner exporter
  # - custom pushgateway metrics
  #########################################################

  #######################################
  # Firewall
  #######################################
  networking.firewall.allowedTCPPorts = [
    4567 # cAdvisor
    9080 # promtail
    9100 # node_exporter
  ];
}
