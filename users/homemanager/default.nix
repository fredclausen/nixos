{
  lib,
  stateVersion,
  system,
  ...
}:
let
  isDarwin = lib.hasSuffix "darwin" system;
  isLinux = !isDarwin;
in
{
  imports = lib.optional isLinux ./linux-xdg.nix;

  home = {
    inherit stateVersion;
  };
}
