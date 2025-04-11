{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.desktop.brave;
in
{
  options.desktop.brave = {
    enable = mkOption {
      description = "Install Brave browser.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    users.users.fred = {
      packages = with pkgs; [
        brave
      ];
    };

    home-manager.users.fred = {
      programs.brave = {
        enable = true;
      };

      catppuccin.brave.enable = true;
    };
  };
}
