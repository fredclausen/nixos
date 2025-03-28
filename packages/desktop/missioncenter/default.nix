{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.desktop.missioncenter;
in
{
  options.desktop.missioncenter = {
    enable = mkOption {
      description = "Enable missioncenter for F1.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    users.users.fred = {
      packages = with pkgs; [
        mission-center
      ];
    };
  };
}
