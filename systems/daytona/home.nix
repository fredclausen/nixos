{ config, pkgs, ... }:

{
  # ------------------------------
  # Host-specific Home Manager overrides for Daytona
  # ------------------------------

  programs.niri.settings = {
    outputs = {
      "eDP-1" = {
        scale = 1.0;

        mode = {
          width = 1920;
          height = 1200;
          refresh = 60.0;
        };
      };
    };

    binds = {
      "XF86MonBrightnessUp".action = {
        spawn = [
          "~/.config/hyprextra/scripts/backlight"
          "64764"
          "--inc"
        ];
      };
      "XF86MonBrightnessDown".action = {
        spawn = [
          "~/.config/hyprextra/scripts/backlight"
          "64764"
          "--dec"
        ];
      };
    };
  };

  wayland.windowManager.hyprland.settings = {
    monitor = [
      ",highres,auto,1"
    ];

    binde = [
      ", XF86MonBrightnessUp, exec, ~/.config/hyprextra/scripts/backlight 64764 --inc"
      ", XF86MonBrightnessDown, exec, ~/.config/hyprextra/scripts/backlight 64764 --dec"
    ];
  };
}
