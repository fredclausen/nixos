{
  lib,
  pkgs,
  config,
  user,
  ...
}:
{
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      xdg.mimeApps.associations.added."x-terminal-emulator" = [ "wezterm.desktop" ];
    };
  };
}
