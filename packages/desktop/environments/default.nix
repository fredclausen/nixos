{
  lib,
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
    desktop.environments = {
      hyprland.enable = true;
      niri.enable = true;
      cosmic.enable = true;
      gnome.enable = true;
    };
  };
}
