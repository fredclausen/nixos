{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.desktop.hyprland.modules.swaync;
in
{
  options.desktop.hyprland.modules.swaync = {
    enable = mkOption {
      description = "Enable swaync.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.fred = {
      services.swaync = {
        enable = true;
        settings = (builtins.fromJSON (builtins.readFile ./config.json));
        # style = builtins.readFile ./style.css;
      };

      catppuccin.swaync = {
        enable = true;
        font = "SFProDisplay Nerd Font";
      };
    };
  };
}
