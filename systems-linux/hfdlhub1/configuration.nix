{
  config,
  pkgs,
  inputs,
  stateVersion,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/adsb-docker-units.nix
  ];

  # Server profile
  desktop.enable = false;
  desktop.enable_extra = false;
  desktop.enable_games = false;
  desktop.enable_streaming = false;

  networking.hostName = "hfdlhub1";

  environment.systemPackages = with pkgs; [ ];

  system.stateVersion = stateVersion;

  system.activationScripts.detect-reboot-required.text = ''
    readlink=${pkgs.coreutils}/bin/readlink
    touch=${pkgs.coreutils}/bin/touch
    rm=${pkgs.coreutils}/bin/rm

    booted="$($readlink /run/booted-system/kernel)"
    current="$($readlink /run/current-system/kernel)"

    if [ "$booted" != "$current" ]; then
      echo "Kernel changed; reboot required"
      $touch /run/reboot-required
    else
      $rm -f /run/reboot-required
    fi
  '';

  sops.secrets = {
    "docker/hfdlhub1/dumphfdl1.env" = {
      format = "yaml";
    };
    "docker/hfdlhub1/dumphfdl2.env" = {
      format = "yaml";
    };
    "docker/hfdlhub1/dumphfdl3.env" = {
      format = "yaml";
    };
  };

  system.activationScripts.adsbDockerCompose = {
    text = ''
      # Ensure directory exists (does not touch contents if already there)
      install -d -m0755 -o fred -g users /opt/adsb
    '';
    deps = [ ];
  };

  services.adsb.containers = [

    ###############################################################
    # DOZZLE AGENT
    ###############################################################
    {
      name = "dozzle-agent";
      image = "amir20/dozzle:v8.14.9";
      exec = "agent";

      volumes = [
        "/var/run/docker.sock:/var/run/docker.sock:ro"
      ];

      ports = [ "7007:7007" ];

      requires = [ "network-online.target" ];
    }

    ###############################################################
    # DUMPHFDL-1
    ###############################################################
    {
      name = "dumphfdl-1";
      image = "ghcr.io/sdr-enthusiasts/docker-dumphfdl:trixie-latest-build-3";

      tty = true;
      restart = "always";

      environmentFiles = [
        config.sops.secrets."docker/hfdlhub1/dumphfdl1.env".path
      ];

      deviceCgroupRules = [
        "c 189:* rwm"
      ];

      tmpfs = [
        "/run:exec,size=64M"
        "/var/log"
        "/tmp"
      ];

      volumes = [
        "/dev:/dev"
        "/opt/adsb/data/dumphfdl1-data:/opt/dumphfdl"
        "/opt/adsb/data/dumphfdl1-scanner:/opt/scanner"
      ];

      requires = [ "network-online.target" ];
    }

    ###############################################################
    # DUMPHFDL-2
    ###############################################################
    {
      name = "dumphfdl-2";
      image = "ghcr.io/sdr-enthusiasts/docker-dumphfdl:trixie-latest-build-3";

      tty = true;
      restart = "always";

      depends_on = {
        "dumphfdl-1" = {
          condition = "service_started";
        };
      };

      environmentFiles = [
        config.sops.secrets."docker/hfdlhub1/dumphfdl2.env".path
      ];

      deviceCgroupRules = [
        "c 189:* rwm"
      ];

      tmpfs = [
        "/run:exec,size=64M"
        "/var/log"
        "/tmp"
      ];

      volumes = [
        "/dev:/dev"
        "/opt/adsb/data/dumphfdl2-data:/opt/dumphfdl"
        "/opt/adsb/data/dumphfdl2-scanner:/opt/scanner"
      ];

      requires = [ "network-online.target" ];
    }

    ###############################################################
    # DUMPHFDL-3
    ###############################################################
    {
      name = "dumphfdl-3";
      image = "ghcr.io/sdr-enthusiasts/docker-dumphfdl:trixie-latest-build-3";

      tty = true;
      restart = "always";

      depends_on = {
        "dumphfdl-1" = {
          condition = "service_started";
        };
        "dumphfdl-2" = {
          condition = "service_started";
        };
      };

      environmentFiles = [
        config.sops.secrets."docker/hfdlhub1/dumphfdl3.env".path
      ];

      deviceCgroupRules = [
        "c 189:* rwm"
      ];

      tmpfs = [
        "/run:exec,size=64M"
        "/var/log"
        "/tmp"
      ];

      volumes = [
        "/dev:/dev"
        "/opt/adsb/data/dumphfdl3-data:/opt/dumphfdl"
        "/opt/adsb/data/dumphfdl3-scanner:/opt/scanner"
      ];

      requires = [ "network-online.target" ];
    }

  ];

}
