{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.desktop.environments;
in
{
  options.desktop.environments = {
    enable = mkOption {
      description = "Enable the desktop environments.";
      default = false;
    };
  };

  imports = [
    ./hyprland
    ./niri
    ./cosmic
    ./gnome
    ./modules
  ];

  config = mkIf cfg.enable {
    desktop.environments.hyprland.enable = true;
    desktop.environments.niri.enable = true;
    desktop.environments.cosmic.enable = true;
    desktop.environments.gnome.enable = true;
  };
}
