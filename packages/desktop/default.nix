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
      description = "Enable desktop environment.";
      default = false;
    };
  };

  imports = [
    ./firefox
    ./brave
    ./fonts
    ./githubdesktop
    ./gnome
    ./print
    ./sqlitebrowser
    ./sublimetext
    ./vscode
    ./1password
  ];

  config = mkIf cfg.enable {
    desktop.brave.enable = true;
    desktop.firefox.enable = true;
    desktop.fonts.enable = true;
    desktop.gnome.enable = true;
    desktop.print.enable = true;
    desktop.githubdesktop.enable = true;
    desktop.vscode.enable = true;
    desktop.onepassword.enable = true;
    desktop.sqlitebrowser.enable = true;
    desktop.sublimetext.enable = true;
  };
}
