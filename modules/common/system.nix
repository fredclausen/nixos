{
  config,
  pkgs,
  inputs,
  lib,
  system,
  ...
}:

let
  isDarwin = lib.hasSuffix "darwin" system;
  isLinux = !isDarwin;
in
{
  imports = [
    # always-safe imports (none for now)
  ]
  # Darwin modules
  ++ lib.optional isDarwin inputs.home-manager.darwinModules.default
  # Linux-only NixOS modules
  ++ lib.optional isLinux inputs.catppuccin.nixosModules.catppuccin
  ++ lib.optional isLinux ../../packages
  ++ lib.optional isLinux ../../users
  ++ lib.optional isLinux ./linux-catpuccin.nix
  ++ lib.optional isLinux ./linux-common.nix;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
