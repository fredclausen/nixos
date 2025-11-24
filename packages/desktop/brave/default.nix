{
  lib,
  pkgs,
  config,
  user,
  ...
}:
with lib;
let
  cfg = config.desktop.brave;
  username = user;
in
{
  options.desktop.brave = {
    enable = mkOption {
      description = "Install Brave browser.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    users.users.${username} = {
      packages = with pkgs; [
        brave
      ];
    };

    home-manager.users.${username} = {
      programs.brave = {
        enable = true;
      };

      catppuccin.brave.enable = true;
    };
  };
}
