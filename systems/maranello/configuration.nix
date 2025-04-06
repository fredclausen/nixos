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
  desktop.enable = true;
  desktop.enable_extra = true;
  desktop.enable_games = true;

  networking.hostName = "maranello"; # Define your hostname.

  environment.systemPackages = with pkgs; [
  ];

  system.stateVersion = "24.11"; # Did you read the comment?

  # specific monitor stuff for this system

  home-manager.users.gdm = {
    home = {
      username = "gdm";
      stateVersion = "24.11";

      file.".config/monitors.xml".text = builtins.readFile ./monitors.xml;
    };
  };

  # virtualisation.virtualbox = {
  #   host = {
  #     enable = true;
  #     enableExtensionPack = true;
  #   };

  #   guest = {
  #     enable = true;
  #   };
  # };

  # users.users.fred = {
  #   extraGroups = [ "vboxusers" ];
  # };

  # users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];

  home-manager.users.fred = {
    home.file.".config/monitors.xml".text = builtins.readFile ./monitors.xml;

    wayland.windowManager.hyprland.settings = {
      monitor = [
        "DP-1, highrr, 0x0, 1"
        "DP-2, highrr, -2560x0, 1"
        "HDMI-A-1, highrr, -2560x-1440, 1"
      ];

      workspace = [
        "1, monitor:DP-1"
        "2, monitor:DP-2"
        "3, monitor:HDMI-A-1"
      ];

      binde = [
        ", XF86MonBrightnessUp, exec, ~/.config/hyprextra/scripts/backlight 255 --inc"
        ", XF86MonBrightnessDown, exec, ~/.config/hyprextra/scripts/backlight 255 --dec"
      ];
    };
  };
}
