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
    home-manager.users.${username} = {
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
