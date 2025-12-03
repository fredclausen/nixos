{
  config,
  pkgs,
  stateVersion,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/secrets/sops.nix
    ../../modules/adsb-docker-units.nix
  ];

  # Server profile
  desktop = {
    enable = false;
    enable_extra = false;
    enable_games = false;
    enable_streaming = false;
  };
  sops_secrets.enable_secrets.enable = true;

  networking.hostName = "acarshub";

  environment.systemPackages = with pkgs; [ ];

  system.stateVersion = stateVersion;

  system.activationScripts.adsbDockerCompose = {
    text = ''
      # Ensure directory exists (does not touch contents if already there)
      install -d -m0755 -o fred -g users /opt/adsb
    '';
    deps = [ ];
  };

  sops.secrets = {
    "github-token" = { };

    "docker/acarshub.env" = {
      format = "yaml";
    };
  };

  services = {
    github-runners = {
      runner-1 = {
        enable = true;
        url = "https://github.com/FredSystems/nixos";
        name = "nixos-acarshub-runner-1";
        tokenFile = config.sops.secrets."github-token".path;
      };

      runner-2 = {
        enable = true;
        url = "https://github.com/FredSystems/nixos";
        name = "nixos-acarshub-runner-2";
        tokenFile = config.sops.secrets."github-token".path;
      };

      # runner-3 = {
      #   enable = true;
      #   url = "https://github.com/FredSystems/nixos";
      #   name = "nixos-acarshub-runner-3";
      #   tokenFile = config.sops.secrets."github-token".path;
      # };

      # runner-4 = {
      #   enable = true;
      #   url = "https://github.com/FredSystems/nixos";
      #   name = "nixos-acarshub-runner-4";
      #   tokenFile = config.sops.secrets."github-token".path;
      # };
    };

    adsb.containers = [
      ###############################################################
      # DOZZLE AGENT
      ###############################################################
      {
        name = "dozzle-agent";
        image = "amir20/dozzle:v8.14.10";
        exec = "agent";

        environmentFiles = [
          config.sops.secrets."docker/acarshub.env".path
        ];

        volumes = [
          "/var/run/docker.sock:/var/run/docker.sock:ro"
        ];

        ports = [ "7007:7007" ];

        requires = [ "network-online.target" ];
      }

      ###############################################################
      # ACARSDEC-1
      ###############################################################
      {
        name = "acarsdec-1";
        image = "ghcr.io/sdr-enthusiasts/docker-acarsdec:trixie-latest-build-4";

        tty = true;
        restart = "always";

        environmentFiles = [
          config.sops.secrets."docker/acarshub.env".path
        ];

        deviceCgroupRules = [
          "c 189:* rwm"
        ];

        environment = {
          SERIAL = "00012785";
          FREQUENCIES = "131.85;131.825;131.725;131.65;131.55;131.525;131.475;131.45;131.425;131.25;131.125;130.85;130.825;130.55;130.45;130.425";
          FEED_ID = "CS-KABQ-ACARS";
          OUTPUT_SERVER = "192.168.31.20";
          OUTPUT_SERVER_MODE = "tcp";
          OUTPUT_SERVER_PORT = "5550";
        };

        tmpfs = [
          "/run:exec,size=64M"
          "/var/log"
        ];

        volumes = [
          "/dev:/dev"
        ];
      }

      ###############################################################
      # ACARSDEC-2
      ###############################################################
      {
        name = "acarsdec-2";
        image = "ghcr.io/sdr-enthusiasts/docker-acarsdec:trixie-latest-build-4";

        tty = true;
        restart = "always";

        environmentFiles = [
          config.sops.secrets."docker/acarshub.env".path
        ];

        deviceCgroupRules = [
          "c 189:* rwm"
        ];

        environment = {
          SERIAL = "00013305";
          FREQUENCIES = "130.025;129.9;129.525;129.35;129.125;129.0";
          FEED_ID = "CS-KABQ-ACARS";
          OUTPUT_SERVER = "192.168.31.20";
          OUTPUT_SERVER_MODE = "tcp";
          OUTPUT_SERVER_PORT = "5550";
        };

        tmpfs = [
          "/run:exec,size=64M"
          "/var/log"
        ];

        volumes = [
          "/dev:/dev"
        ];
      }

      ###############################################################
      # ACARSDEC-3
      ###############################################################
      {
        name = "acarsdec-3";
        image = "ghcr.io/sdr-enthusiasts/docker-acarsdec:trixie-latest-build-4";

        tty = true;
        restart = "always";

        environmentFiles = [
          config.sops.secrets."docker/acarshub.env".path
        ];

        deviceCgroupRules = [
          "c 189:* rwm"
        ];

        environment = {
          SERIAL = "00012095";
          FREQUENCIES = "136.975;136.8;136.65";
          FEED_ID = "CS-KABQ-ACARS";
          OUTPUT_SERVER = "192.168.31.20";
          OUTPUT_SERVER_MODE = "tcp";
          OUTPUT_SERVER_PORT = "5550";
        };

        tmpfs = [
          "/run:exec,size=64M"
          "/var/log"
        ];

        volumes = [
          "/dev:/dev"
        ];
      }
    ];
  };
}
