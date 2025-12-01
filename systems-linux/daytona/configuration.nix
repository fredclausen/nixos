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
    enable_games = false;
    enable_streaming = false;
  };

  sops_secrets.enable_secrets.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_testing;

  networking = {
    hostName = "Daytona";
    networkmanager.wifi.scanRandMacAddress = false;
  };

  services = {
    logind = {
      settings = {
        Login = {
          HandleLidSwitch = "suspend";
          HandlePowerKey = "suspend";
        };
      };
    };

    fprintd = {
      enable = true;
      tod.enable = true;
      tod.driver = pkgs.libfprint-2-tod1-goodix;
    };
  };

  powerManagement.enable = true;

  environment.systemPackages = with pkgs; [ ];

  system.stateVersion = stateVersion;

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
