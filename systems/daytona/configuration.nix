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
  desktop.enable_games = false;
  desktop.enable_streaming = false;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_testing;

  catppuccin = {
    flavor = "mocha";
    accent = "lavender";
    enable = true;
  };

  networking.hostName = "Daytona"; # Define your hostname.
  networking.networkmanager.wifi.scanRandMacAddress = false;

  environment.systemPackages = with pkgs; [
  ];

  services.logind = {

    extraConfig = "HandlePowerKey=suspend";

    lidSwitch = "suspend";

  };

  powerManagement.enable = true;

  home-manager.users.fred = {
    wayland.windowManager.hyprland.settings = {
      monitor = [
        ",highres,auto,1"
      ];

      binde = [
        ", XF86MonBrightnessUp, exec, ~/.config/hyprextra/scripts/backlight 64764 --inc"
        ", XF86MonBrightnessDown, exec, ~/.config/hyprextra/scripts/backlight 64764 --dec"
      ];
    };
  };

  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;
  system.stateVersion = "24.11"; # Did you read the comment?
}
