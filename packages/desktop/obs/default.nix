{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
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
    users.users.fred = {
      packages = with pkgs; [
        obs-studio
        obs-studio-plugins.wlrobs
        obs-studio-plugins.obs-vkcapture
        streamcontroller
      ];
    };
  };
}
