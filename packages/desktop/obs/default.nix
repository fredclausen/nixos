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
  cfg = config.desktop.obs;
in
{
  options.desktop.obs = {
    # Updated to match the new configuration
    enable = mkOption {
      description = "Enable StreamLab";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.udev = {
      packages = with pkgs; [
        streamcontroller
      ];
    };

    users.users.${username} = {
      packages = with pkgs; [
        obs-studio
        obs-studio-plugins.wlrobs
        obs-studio-plugins.obs-vkcapture
        streamcontroller
      ];
    };

    home-manager.users.${username} = {
      programs.obs-studio = {
        enable = true;
      };

      catppuccin.obs.enable = true;
    };
  };
}
