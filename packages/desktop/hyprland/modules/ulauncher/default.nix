{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.desktop.hyprland.modules.ulauncher;
in
{
  options.desktop.hyprland.modules.ulauncher = {
    enable = mkOption {
      description = "Enable ulauncher.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    users.users.fred = {
      packages = with pkgs; [
        ulauncher
      ];
    };
  };
}
