{ config, pkgs, ... }:

{
  # Host-specific Home Manager config for maranello

  # Per-user monitors.xml in $HOME
  home.file.".config/monitors.xml".text = builtins.readFile ./monitors.xml;

  programs.niri.settings = {
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
      ", XF86MonBrightnessUp, exec, ~/.config/hyprextra/scripts/backlight 255 --inc"
      ", XF86MonBrightnessDown, exec, ~/.config/hyprextra/scripts/backlight 255 --dec"
    ];
  };
}
