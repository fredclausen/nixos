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
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # extra options
  desktop = {
    enable = true;
    enable_extra = true;
    enable_games = true;
    enable_streaming = true;
  };
  sops_secrets.enable_secrets.enable = true;

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_testing;
  networking.hostName = "maranello";

  environment.systemPackages = with pkgs; [ ];

  system.stateVersion = stateVersion;

  systemd.tmpfiles.rules = [
    "d /var/lib/gdm/.config 0755 gdm gdm -"
    "f /var/lib/gdm/.config/monitors.xml 0644 gdm gdm - ${./monitors.xml}"
  ];

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
