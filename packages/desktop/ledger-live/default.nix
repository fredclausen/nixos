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
    users.users.fred = {
      packages = with pkgs; [
        ledger-live-desktop
      ];
    };
  };
}
