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
    ./fuzzel
    ./pamixer
  ];

  config = mkIf cfg.enable {
    desktop.hyprland.modules.pamixer.enable = true;
    desktop.hyprland.modules.fuzzel.enable = true;
  };
}
