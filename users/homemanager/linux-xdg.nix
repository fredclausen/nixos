{
  pkgs,
  lib,
  user,
  stateVersion,
  ...
}:
let
  username = user;
in
with lib.hm.gvariant;
{
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = false;
    };

    mimeApps = {
      enable = true;
    };
  };

  fonts.fontconfig.enable = true;
}
