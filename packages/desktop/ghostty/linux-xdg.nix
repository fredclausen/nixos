{
  lib,
  pkgs,
  config,
  user,
  ...
}:
let
  username = user;
in
{
  config = {
    home-manager.users.${username} = {
      xdg.mimeApps = {
        associations.added."x-terminal-emulator" = [ "ghostty.desktop" ];
        defaultApplications."x-terminal-emulator" = [ "ghostty.desktop" ];
      };
    };
  };
}
