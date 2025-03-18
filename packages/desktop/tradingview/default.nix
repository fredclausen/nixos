{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.desktop.tradingview;
in
{
  options.desktop.tradingview = {
    enable = mkOption {
      description = "Enable Trading View.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    users.users.fred = {
      packages = with pkgs; [
        tradingview
      ];
    };
  };
}
