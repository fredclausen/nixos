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
    users.users.${username} = {
      packages = with pkgs; [
        vlc
      ];
    };
  };
}
