{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.desktop.vlc;
in
{
  options.desktop.vlc = {
    enable = mkOption {
      description = "Enable VLC.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    users.users.fred = {
      packages = with pkgs; [
        vlc
      ];
    };
  };
}
