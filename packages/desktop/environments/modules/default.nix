{
  lib,
  pkgs,
  config,
  hmlib,
  ...
}:
with lib;
let
  cfg = config.desktop.environments.modules;
in
{
  options.desktop.environments.modules = {
    enable = mkOption {
      description = "Install Hyprland/Niri desktop modules.";
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
    desktop.environments.modules.clipboard.enable = true;
    desktop.environments.modules.hyprlandextra.enable = true;
    desktop.environments.modules.pamixer.enable = true;
    desktop.environments.modules.fuzzel.enable = true;
    desktop.environments.modules.waybar.enable = true;
    desktop.environments.modules.swaync.enable = true;
    desktop.environments.modules.ulauncher.enable = true;
  };
}
