{
  config,
  pkgs,
  inputs,
  stateVersion,
  ...
}:
let
  dockerSecrets = builtins.fromJSON (
    builtins.readFile config.sops.secrets."docker/acarshub.env".path
  );
in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/adsb-quadlet.nix
  ];

  # Server profile
  desktop.enable = false;
  desktop.enable_extra = false;
  desktop.enable_games = false;
  desktop.enable_streaming = false;

  networking.hostName = "acarshub";

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

  services.adsb.containers = [
    ###############################################################
    # DOZZLE
    ###############################################################
    {
      name = "dozzle-agent";
      image = "amir20/dozzle:v8.14.9";
      exec = "agent";

      volumes = [
        "/var/run/docker.sock:/var/run/docker.sock:ro"
      ];

      ports = [ "7007:7007" ];
    }

    ###############################################################
    # ACARSDEC-1
    ###############################################################
    {
      name = "acarsdec-1";
      image = "ghcr.io/sdr-enthusiasts/docker-acarsdec:trixie-latest-build-4";

      tty = true;
      restart = "always";

      environment = {
        TZ = dockerSecrets.FEEDER_TZ;
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

      devices = [ "/dev" ];
    }

    ###############################################################
    # ACARSDEC-2
    ###############################################################
    {
      name = "acarsdec-2";
      image = "ghcr.io/sdr-enthusiasts/docker-acarsdec:trixie-latest-build-4";
      tty = true;
      restart = "always";

      environment = {
        TZ = dockerSecrets.FEEDER_TZ;
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

      devices = [ "/dev" ];
    }

    ###############################################################
    # ACARSDEC-3
    ###############################################################
    {
      name = "acarsdec-3";
      image = "ghcr.io/sdr-enthusiasts/docker-acarsdec:trixie-latest-build-4";
      tty = true;
      restart = "always";

      environment = {
        TZ = dockerSecrets.FEEDER_TZ;
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

      devices = [ "/dev" ];
    }
  ];
}
