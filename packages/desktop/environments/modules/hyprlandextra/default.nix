{
  lib,
  pkgs,
  config,
  user,
  ...
}:
with lib;
let
  username = user;
  cfg = config.desktop.environments.modules.hyprlandextra;
in
{
  options.desktop.environments.modules.hyprlandextra = {
    enable = mkOption {
      description = "Enable extra stuff for hyprland.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      home.file.".config/hyprextra/" = {
        source = ./hyprextra;
        recursive = true;
      };
    };
  };
}
