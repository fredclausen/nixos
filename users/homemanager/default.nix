{
  pkgs,
  lib,
  user,
  stateVersion,
  system,
  ...
}:
let
  username = user;
  isDarwin = lib.hasSuffix "darwin" system;
  isLinux = !isDarwin;
in
with lib.hm.gvariant;
{
  imports = lib.optional isLinux ./linux-xdg.nix;

  home = {
    stateVersion = stateVersion;
  };
}
