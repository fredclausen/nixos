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
    home-manager.users.${username} = {
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
