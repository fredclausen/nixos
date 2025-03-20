{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.desktop.hyprland.modules.pamixer;
in
{
  options.desktop.hyprland.modules.pamixer = {
    enable = mkOption {
      description = "Enable pamixer.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    users.users.fred = {
      packages = with pkgs; [
        pamixer
      ];
    };
  };
}
