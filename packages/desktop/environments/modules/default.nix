{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.desktop.environments.modules;
in
{
  options.desktop.environments.modules = {
    enable = mkOption {
      description = "Install Hyprland/Niri desktop modules.";
      default = false;
    };
  };
  imports = [
    ./clipboard
    ./fuzzel
    ./hyprlandextra
    ./pamixer
    ./swaync
    ./vicinae
    ./waybar
  ];

  config = mkIf cfg.enable {
    desktop.environments.modules = {
      clipboard.enable = true;
      hyprlandextra.enable = true;
      pamixer.enable = true;
      fuzzel.enable = true;
      vicinae.enable = true;
      waybar.enable = true;
      swaync.enable = true;
    };
  };
}
