{
  config,
  pkgs,
  stateVersion,
  ...
}:
let
  hfdlObserver = pkgs.writeText "settings.yaml" (
    builtins.readFile ./docker-data/hfdlobserver/settings.yaml
  );
in
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

  networking.hostName = "hfdlhub2";

  environment.systemPackages = with pkgs; [ ];

  system.stateVersion = stateVersion;

  sops.secrets = {
    "docker/hfdlhub2.env" = {
      format = "yaml";
    };
  };

  system.activationScripts.adsbDockerCompose = {
    text = ''
      # Ensure directory exists (does not touch contents if already there)
      install -d -m0755 -o fred -g users /opt/adsb

      install -d -m0755 -o fred -g users /opt/adsb/hfdlobserver

      # Always overwrite the compose file from the Nix store
      install -m0644 -o fred -g users ${hfdlObserver} /opt/adsb/hfdlobserver/settings.yaml
    '';
    deps = [ ];
  };

  services.adsb.containers = [

    ###############################################################
    # DOZZLE AGENT
    ###############################################################
    {
      name = "dozzle-agent";
      image = "amir20/dozzle:v8.14.10";
      exec = "agent";

      environmentFiles = [
        config.sops.secrets."docker/hfdlhub2.env".path
      ];

      volumes = [
        "/var/run/docker.sock:/var/run/docker.sock:ro"
      ];

      ports = [ "7007:7007" ];

      requires = [ "network-online.target" ];
    }

    ###############################################################
    # HFDLOBserver
    ###############################################################
    # {
    #   name = "hfdlobserver";
    #   image = "ghcr.io/sdr-enthusiasts/docker-hfdlobserver:latest-build-14";

    #   environmentFiles = [
    #     config.sops.secrets."docker/hfdlhub2.env".path
    #   ];

    #   volumes = [
    #     "/opt/adsb/hfdlobserver:/run/hfdlobserver"
    #   ];

    #   requires = [ "network-online.target" ];
    # }

  ];
}
