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
  ]
  # Darwin modules
  ++ lib.optional isDarwin inputs.home-manager.darwinModules.default
  ++ lib.optional isDarwin ../homebrew.nix
  # Linux-only NixOS modules
  ++ lib.optional isLinux inputs.catppuccin.nixosModules.catppuccin
  ++ lib.optional isLinux ../../packages
  ++ lib.optional isLinux ../../users
  ++ lib.optional isLinux ./linux-catpuccin.nix;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
