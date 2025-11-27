{
  config,
  pkgs,
  inputs,
  user,
  stateVersion,
  ...
}:
let
  username = user;
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # extra options
  desktop.enable = true;
  desktop.enable_extra = true;
  desktop.enable_games = true;
  desktop.enable_streaming = true;

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_testing;
  networking.hostName = "maranello";

  environment.systemPackages = with pkgs; [ ];

  system.stateVersion = stateVersion;

  systemd.tmpfiles.rules = [
    "d /var/lib/gdm/.config 0755 gdm gdm -"
    "f /var/lib/gdm/.config/monitors.xml 0644 gdm gdm - ${./monitors.xml}"
  ];

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
    # wifi
    "wifi.env" = { };
  };

  networking.networkmanager = {
    enable = true;

    ensureProfiles = {
      environmentFiles = [
        config.sops.secrets."wifi.env".path
      ];

      profiles = {
        "Home" = {
          connection.id = "Home";
          connection.type = "wifi";

          wifi.ssid = "$home_ssid";

          wifi-security = {
            key-mgmt = "wpa-psk";
            psk = "$home_psk";
          };
        };

        "Work" = {
          connection.id = "Work";
          connection.type = "wifi";

          wifi.ssid = "$work_ssid";

          wifi-security = {
          };
        };

        "Parents" = {
          connection.id = "Parents";
          connection.type = "wifi";

          wifi.ssid = "$parents_ssid";

          wifi-security = {
            key-mgmt = "wpa-psk";
            psk = "$parents_psk";
          };
        };
      };
    };
  };
}
