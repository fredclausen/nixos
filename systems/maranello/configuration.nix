{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
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
  desktop.enable_streaming = true;

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_testing;
  networking.hostName = "maranello";

  environment.systemPackages = with pkgs; [ ];

  system.stateVersion = "24.11";

  systemd.tmpfiles.rules = [
    "d /var/lib/gdm/.config 0755 gdm gdm -"
    "f /var/lib/gdm/.config/monitors.xml 0644 gdm gdm - ${./monitors.xml}"
  ];
}
