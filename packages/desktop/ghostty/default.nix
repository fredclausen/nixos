{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.desktop.ghostty;
in
{
  options.desktop.ghostty = {
    enable = mkOption {
      description = "Enable Ghostty.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.fred = {
      home.packages = with pkgs; [
        ghostty
      ];

      programs.ghostty = {
        enable = true;

        settings = {
          font-family = "Caskaydia Cove Nerd Font";
          font-size = 12;
          background-opacity = 0.95;
        };
      };

      catppuccin.ghostty.enable = true;

      xdg = {
        mimeApps = {
          associations.added = {
            "x-terminal-emulator" = [ "ghostty.desktop" ];
          };

          defaultApplications = {
            "x-terminal-emulator" = [ "ghostty.desktop" ];
          };
        };
      };
    };
  };
}
