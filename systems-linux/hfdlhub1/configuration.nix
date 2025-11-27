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

  system.activationScripts.adsbDockerCompose = {
    text = ''
      # Ensure directory exists (does not touch contents if already there)
      install -d -m0755 -o fred -g users /opt/adsb

      # Always overwrite the compose file from the Nix store
      install -m0644 -o fred -g users ${dockerCompose} /opt/adsb/docker-compose.yaml
    '';
    deps = [ ];
  };

  sops.secrets = {
    "docker/hfdlhub1.env" = {
      path = "/opt/adsb/.env";
      owner = "fred";
    };
  };
}
