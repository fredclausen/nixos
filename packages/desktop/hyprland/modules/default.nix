{
  lib,
  pkgs,
  config,
  hmlib,
  ...
}:
with lib;
let
  cfg = config.desktop.hyprland.modules;
in
{
  options.desktop.hyprland.modules = {
    enable = mkOption {
      description = "Install Hyprland desktop modules.";
      default = false;
    };
  };
  imports = [
    ./clipboard
    ./fuzzel
    ./hyprlandextra
    ./pamixer
    ./swaync
    ./ulauncher
    ./waybar
  ];

  config = mkIf cfg.enable {
    desktop.hyprland.modules.clipboard.enable = true;
    desktop.hyprland.modules.hyprlandextra.enable = true;
    desktop.hyprland.modules.pamixer.enable = true;
    desktop.hyprland.modules.fuzzel.enable = true;
    desktop.hyprland.modules.waybar.enable = true;
    desktop.hyprland.modules.swaync.enable = true;
    desktop.hyprland.modules.ulauncher.enable = true;
  };
}
