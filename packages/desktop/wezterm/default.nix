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
      programs.wezterm = {
        enable = true;
      };

      catppuccin.wezterm.enable = true;
      catppuccin.wezterm.apply = true;

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
