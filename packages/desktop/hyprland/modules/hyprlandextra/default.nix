{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.desktop.hyprland.modules.hyprlandextra;
in
{
  options.desktop.hyprland.modules.hyprlandextra = {
    enable = mkOption {
      description = "Enable extra stuff for hyprland.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.fred = {
      home.file.".config/hyprextra/" = {
        source = ./hyprextra;
        recursive = true;
      };
    };
  };
}
