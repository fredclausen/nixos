{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.desktop.multiviewer;
in
{
  options.desktop.multiviewer = {
    enable = mkOption {
      description = "Enable Multiviewer for F1.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    users.users.fred = {
      packages = with pkgs; [
        multiviewer-for-f1
      ];
    };
  };
}
