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
    users.users.${username} = {
      packages = with pkgs; [
        mission-center
      ];
    };
  };
}
