{ config, ... }:
{
  systemd.tmpfiles.rules = [
    "d /var/lib/promtail 0755 promtail promtail -"
  ];

  users.users.promtail.extraGroups = [ "docker" ];

  networking.firewall.allowedTCPPorts = [
    9080 # promtail
  ];

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
  };
}
