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

    enable_extra = mkOption {
      description = "Enable extra desktop applications. This will turn on packages that do not work on arm64.";
      default = false;
    };
  };

  imports = [
    ./alacritty
    ./firefox
    ./brave
    ./discord
    ./fonts
    ./githubdesktop
    ./ghostty
    ./gnome
    ./print
    ./sqlitebrowser
    ./sublimetext
    ./tradingview
    ./vscode
    ./1password
    ./wezterm
    ./hyprland
    ./steam
    ./stockfish
  ];

  config = mkIf cfg.enable {
    desktop.brave.enable = true;
    desktop.firefox.enable = true;
    desktop.fonts.enable = true;
    desktop.ghostty.enable = true;
    desktop.gnome.enable = true;
    desktop.print.enable = true;
    desktop.githubdesktop.enable = true;
    desktop.vscode.enable = true;
    desktop.onepassword.enable = true;
    desktop.sqlitebrowser.enable = true;
    desktop.sublimetext.enable = true;
    desktop.wezterm.enable = true;
    desktop.alacritty.enable = true;
    desktop.hyprland.enable = true;
    desktop.stockfish.enable = true;

    desktop.discord.enable = if cfg.enable_extra then true else false;
    desktop.tradingview.enable = if cfg.enable_extra then true else false;
    desktop.steam.enable = if cfg.enable_extra then true else false;
  };
}
