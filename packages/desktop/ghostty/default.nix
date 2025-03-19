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
          font-family = "MesloLGS Nerd Font Mono";
          font-size = 10;
          theme = "Wez";
        };
      };

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
