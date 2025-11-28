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

  boot.kernelParams = [
    "usbcore.usbfs_memory_mb=1000"
  ];

  networking.hostName = "vdlmhub";

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

  system.activationScripts.adsbDockerCompose = {
    text = ''
      # Ensure directory exists (does not touch contents if already there)
      install -d -m0755 -o fred -g users /opt/adsb
    '';
    deps = [ ];
  };

  sops.secrets = {
    "docker/vdlmhub/dumpvdl2-1.env" = {
      format = "yaml";
    };
    "docker/vdlmhub/dumpvdl2-2.env" = {
      format = "yaml";
    };
    "docker/vdlmhub/dumpvdl2-3.env" = {
      format = "yaml";
    };
    "docker/vdlmhub/dumpvdl2-4.env" = {
      format = "yaml";
    };
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
    }

    ###############################################################
    # dumpvdl2-1
    ###############################################################
    {
      name = "dumpvdl2-1";
      image = "ghcr.io/sdr-enthusiasts/docker-dumpvdl2:trixie-latest-build-5";

      tty = true;
      restart = "always";

      environmentFiles = [
        config.sops.secrets."docker/vdlmhub/dumpvdl2-1.env".path
      ];

      deviceCgroupRules = [
        "c 189:* rwm"
      ];

      tmpfs = [
        "/run:exec,size=64M"
        "/var/log"
      ];

      volumes = [
        "/dev:/dev"
      ];
    }

    ###############################################################
    # dumpvdl2-2
    ###############################################################
    {
      name = "dumpvdl2-2";
      image = "ghcr.io/sdr-enthusiasts/docker-dumpvdl2:trixie-latest-build-5";

      tty = true;
      restart = "always";

      environmentFiles = [
        config.sops.secrets."docker/vdlmhub/dumpvdl2-2.env".path
      ];

      deviceCgroupRules = [
        "c 189:* rwm"
      ];

      tmpfs = [
        "/run:exec,size=64M"
        "/var/log"
      ];

      volumes = [
        "/dev:/dev"
      ];
    }

    ###############################################################
    # dumpvdl2-3
    ###############################################################
    {
      name = "dumpvdl2-3";
      image = "ghcr.io/sdr-enthusiasts/docker-dumpvdl2:trixie-latest-build-5";

      tty = true;
      restart = "always";

      environmentFiles = [
        config.sops.secrets."docker/vdlmhub/dumpvdl2-3.env".path
      ];

      deviceCgroupRules = [
        "c 189:* rwm"
      ];

      tmpfs = [
        "/run:exec,size=64M"
        "/var/log"
      ];

      volumes = [
        "/dev:/dev"
      ];
    }

    ###############################################################
    # dumpvdl2-4
    ###############################################################
    {
      name = "dumpvdl2-4";
      image = "ghcr.io/sdr-enthusiasts/docker-dumpvdl2:trixie-latest-build-5";

      tty = true;
      restart = "always";

      environmentFiles = [
        config.sops.secrets."docker/vdlmhub/dumpvdl2-4.env".path
      ];

      deviceCgroupRules = [
        "c 189:* rwm"
      ];

      tmpfs = [
        "/run:exec,size=64M"
        "/var/log"
      ];

      volumes = [
        "/dev:/dev"
      ];
    }
  ];
}
