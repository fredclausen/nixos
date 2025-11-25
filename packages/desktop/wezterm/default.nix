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
  isDarwin = pkgs.stdenv.isDarwin;
  weztermConfig =
    if isDarwin then
      ../../../dotfiles/fred/.wezterm_darwin.lua
    else
      ../../../dotfiles/fred/.wezterm.lua;
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

        extraConfig = builtins.readFile weztermConfig;
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
