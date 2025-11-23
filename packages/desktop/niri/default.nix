{
  lib,
  pkgs,
  config,
  inputs,
  imports,
  ...
}:
with lib;
let
  cfg = config.desktop.niri;
in
{
  options.desktop.niri = {
    enable = mkOption {
      description = "Install Niri.";
      default = false;
    };
  };

  imports = [ inputs.niri.nixosModules.niri ];

  config = mkIf cfg.enable {
    programs.niri = {
      enable = true;
      # settings = {
      # Example: Set scale for a specific output
      # outputs."eDP-1".scale = 2.0;

      # # Example: Define keybindings
      # keybinds = {
      #     "Super-t" = "spawn wezterm"; # Open WezTerm with Super+t
      #     "Super-d" = "spawn fuzzel";    # Open Fuzzel launcher with Super+d
      #     "Super-Shift-e" = "exit";      # Exit Niri with Super+Shift+e
      # };

      # # Example: Configure themes or other visual aspects
      # # theme.colors.background = "#282a36";
      # };
    };

    home-manager.users.fred = {
      xdg = {
        mimeApps = {
          associations.added = {
            "text/html" = [ "firefox.desktop" ];
            "x-scheme-handler/http" = [ "firefox.desktop" ];
            "x-scheme-handler/https" = [ "firefox.desktop" ];
            "x-scheme-handler/about" = [ "firefox.desktop" ];
            "x-scheme-handler/unknown" = [ "firefox.desktop" ];
          };

          defaultApplications = {
            "text/html" = [ "firefox.desktop" ];
            "x-scheme-handler/http" = [ "firefox.desktop" ];
            "x-scheme-handler/https" = [ "firefox.desktop" ];
            "x-scheme-handler/about" = [ "firefox.desktop" ];
            "x-scheme-handler/unknown" = [ "firefox.desktop" ];
          };
        };
      };
    };
  };
}
