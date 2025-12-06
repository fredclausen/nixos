{
  systemd.tmpfiles.rules = [
    "d /var/lib/loki 0750 loki loki -"
  ];

  networking.firewall.allowedTCPPorts = [
    5678 # Loki
  ];

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
  };
}
