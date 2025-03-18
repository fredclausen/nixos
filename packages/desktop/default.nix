{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.desktop;
in
{
  options.desktop = {
    enable = mkOption {
      description = "Install Brave browser.";
      default = false;
    };
  };

  imports = [
    ./firefox
    ./brave
    ./fonts
    ./gnome
    ./print
  ];

  config = mkIf cfg.enable {
    desktop.brave.enable = true;
    desktop.firefox.enable = true;
    desktop.fonts.enable = true;
    desktop.gnome.enable = true;
    desktop.print.enable = true;
  };
}
