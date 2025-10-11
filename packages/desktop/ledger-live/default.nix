{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.desktop.ledger;
in
{
  options.desktop.ledger = {
    enable = mkOption {
      description = "Install Ledger Live desktop application.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    hardware.ledger.enable = true;

    services = {
      udev.packages = with pkgs; [
        ledger-udev-rules
        # potentially even more if you need them
      ];
    };

    users.users.fred = {
      packages = with pkgs; [
        ledger-live-desktop
      ];
    };
  };
}
