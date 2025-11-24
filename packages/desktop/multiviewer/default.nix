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
    users.users.${username} = {
      packages = with pkgs; [
        multiviewer-for-f1
      ];
    };
  };
}
