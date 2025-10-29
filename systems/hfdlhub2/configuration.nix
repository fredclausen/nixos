# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
    ../../packages
    ../../users
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # extra options
  desktop.enable = false;
  desktop.enable_extra = false;
  desktop.enable_games = false;
  desktop.enable_streaming = false;

  catppuccin = {
    flavor = "mocha";
    accent = "lavender";
    enable = true;
  };

  home.file."./.config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink "/home/fred/GitHub/nixos/dotfiles/fred/.config/nvim";

  networking.hostName = "hfdlhub2"; # Define your hostname.

  environment.systemPackages = with pkgs; [
  ];

  system.stateVersion = "24.11"; # Did you read the comment?
}
