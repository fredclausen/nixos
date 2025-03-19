{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.desktop.wezterm;
in
{
  options.desktop.wezterm = {
    enable = mkOption {
      description = "Enable WezTerm.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.fred = {
      home.packages = with pkgs; [
        wezterm
      ];

      programs.wezterm = {
        enable = true;
        extraConfig = builtins.readFile ../../../dotfiles/fred/.wezterm.lua;
      };

      xdg = {
        mimeApps = {
          associations.added = {
            "x-terminal-emulator" = [ "wezterm.desktop" ];
          };
        };
      };
    };
  };
}
