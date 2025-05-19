{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.desktop.cosmic;
in
{
  options.desktop.cosmic = {
    enable = mkOption {
      description = "Enable Cosmic.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.desktopManager.cosmic.enable = true;
  };
}
