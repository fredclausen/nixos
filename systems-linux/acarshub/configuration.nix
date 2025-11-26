{
  config,
  pkgs,
  inputs,
  stateVersion,
  ...
}:
let
  dockerCompose = pkgs.writeText "docker-compose.yaml" (builtins.readFile ./docker-compose.yaml);
in
{
  imports = [
    ./hardware-configuration.nix
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

  systemd.tmpfiles.rules = [
    "d /opt/adsb 0755 fred users - -"
    "C! /opt/adsb/docker-compose.yaml 0644 fred users - ${dockerCompose}"
  ];

  sops.secrets = {
    "docker/acarshub.env" = {
      path = "/opt/adsb/.env";
      owner = "fred";
    };
  };
}
