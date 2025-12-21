{
  user,
  ...
}:
let
  username = user;
in
{
  # Host-specific Home Manager config for maranello
  imports = [
    ../../modules/sync-compose.nix
    ../../modules/ansible/ansible.nix
    ../../modules/nas-home.nix
  ];

  # Per-user monitors.xml in $HOME
  home.file.".config/monitors.xml".text = builtins.readFile ./monitors.xml;

  nas = {
    enable = true;

    mounts = [
      {
        path = "/mnt/nas/fred";
        host = "192.168.31.16";
        share = "/volume1/Fred Share";
        type = "nfs";
        gvfsName = "Fred Share";
      }

      {
        path = "/mnt/nas/discord";
        host = "192.168.31.16";
        share = "/volume1/discord";
        type = "nfs";
        gvfsName = "Discord";
      }

      {
        path = "/mnt/nas/dropbox";
        host = "192.168.31.16";
        share = "/volume1/Dropbox";
        type = "nfs";
        gvfsName = "Dropbox";
      }

      {
        path = "/mnt/nas/media";
        host = "192.168.31.16";
        share = "/volume1/Media";
        type = "nfs";
        gvfsName = "Media";
      }

      {
        path = "/mnt/nas/prometheus";
        host = "192.168.31.16";
        share = "/volume1/Prometheus";
        type = "nfs";
        gvfsName = "Prometheus";
      }
    ];
  };

  programs = {
    ansible.enable = true;

    sync-compose = {
      enable = true;
      user = username; # comes from flake.nix

      hosts = [
        # SDR Hub
        {
          name = "sdrhub";
          ip = "192.168.31.20";
          directory = "sdrhub";
          remotePath = "/opt/adsb";
          port = "22";
          legacyScp = false;
        }

        # HFDL Hub 1
        {
          name = "hfdlhub-1";
          ip = "192.168.31.19";
          directory = "hfdlhub-1";
          remotePath = "/opt/adsb";
          port = "22";
          legacyScp = false;
        }

        # HFDL Hub 2
        {
          name = "hfdlhub-2";
          ip = "192.168.31.17";
          directory = "hfdlhub-2";
          remotePath = "/opt/adsb";
          port = "22";
          legacyScp = false;
        }

        # ACARS Hub
        {
          name = "acarshub";
          ip = "192.168.31.24";
          directory = "acarshub";
          remotePath = "/opt/adsb";
          port = "22";
          legacyScp = false;
        }

        # VDL Hub
        {
          name = "vdlmhub";
          ip = "192.168.31.23";
          directory = "vdlmhub";
          remotePath = "/opt/adsb";
          port = "22";
          legacyScp = false;
        }

        # VPS (fredclausen.com)
        {
          name = "vps";
          ip = "fredclausen.com";
          directory = "vps";
          remotePath = "/home/${user}";
          port = "22";
          legacyScp = false;
        }

        # Brandon (special port + legacy scp)
        {
          name = "brandon";
          ip = "73.242.200.187";
          directory = "brandon";
          remotePath = "/opt/adsb";
          port = "3222";
          legacyScp = true;
        }
      ];
    };

    niri.settings = {
      outputs = {
        "DP-1" = {
          scale = 1.0;
          mode = {
            width = 2560;
            height = 1440;
            refresh = 144.0;
          };
          position = {
            x = 0;
            y = 0;
          };
        };

        "DP-2" = {
          scale = 1.0;
          mode = {
            width = 2560;
            height = 1440;
            refresh = 144.0;
          };
          position = {
            x = -2560;
            y = 0;
          };
        };

        "HDMI-A-1" = {
          scale = 1.0;
          mode = {
            width = 2560;
            height = 1440;
            refresh = 60.0;
          };
          position = {
            x = -2560;
            y = -1440;
          };
        };
      };
    };
  };

  wayland.windowManager.hyprland.settings = {
    monitor = [
      "DP-1, highrr, 0x0, 1"
      "DP-2, highrr, -2560x0, 1"
      "HDMI-A-1, highrr, -2560x-1440, 1"
    ];

    workspace = [
      "1, monitor:DP-1"
      "2, monitor:DP-2"
      "3, monitor:HDMI-A-1"
    ];

    binde = [
      ", XF86MonBrightnessUp, exec, ~/.config/hyprextra/scripts/backlight.sh 255 --inc"
      ", XF86MonBrightnessDown, exec, ~/.config/hyprextra/scripts/backlight.sh 255 --dec"
    ];
  };
}
