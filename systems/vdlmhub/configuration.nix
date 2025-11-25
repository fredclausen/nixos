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

  # Server profile
  desktop.enable = false;
  desktop.enable_extra = false;
  desktop.enable_games = false;
  desktop.enable_streaming = false;

  boot.kernelParams = [
    "usbcore.usbfs_memory_mb=1000"
  ];

  networking.hostName = "vdlmhub";

  environment.systemPackages = with pkgs; [ ];

  system.stateVersion = stateVersion;
}
