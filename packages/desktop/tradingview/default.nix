{
  lib,
  pkgs,
  config,
  user,
  ...
}:
with lib;
let
  username = user;
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
    users.users.${username} = {
      packages = with pkgs; [
        tradingview
      ];
    };
  };
}
