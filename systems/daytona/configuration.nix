{
  config,
  pkgs,
  inputs,
  stateVersion,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
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

  networking.hostName = "Daytona";
  networking.networkmanager.wifi.scanRandMacAddress = false;

  services.logind = {
    settings = {
      Login = {
        HandleLidSwitch = "suspend";
        HandlePowerKey = "suspend";
      };
    };
  };

  powerManagement.enable = true;

  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;

  environment.systemPackages = with pkgs; [ ];

  system.stateVersion = stateVersion;
}
