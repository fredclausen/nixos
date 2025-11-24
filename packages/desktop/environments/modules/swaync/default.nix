{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.desktop.environments.modules.swaync;
in
{
  options.desktop.environments.modules.swaync = {
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
      };

      catppuccin.swaync = {
        enable = true;
        font = "SFProDisplay Nerd Font";
      };
    };
  };
}
