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

    enable_games = mkOption {
      description = "Enable games.";
      default = false;
    };

    enable_streaming = mkOption {
      description = "Enable streaming applications.";
      default = false;
    };
  };

  imports = [
    ./1password
    ./alacritty
    ./appimage
    ./audio
    ./brave
    ./cosmic
    ./discord
    ./firefox
    ./fonts
    ./ghostty
    ./githubdesktop
    ./gnome
    ./hyprland
    ./ladybird
    ./libreoffice
    ./missioncenter
    ./multiviewer
    ./music
    ./obs
    ./print
    ./sqlitebrowser
    ./steam
    ./stockfish
    ./sublimetext
    ./tradingview
    ./vlc
    ./vscode
    ./wezterm
    ./wireshark
  ];

  config = mkIf cfg.enable {
    desktop.brave.enable = true;
    desktop.cosmic.enable = true;
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
    desktop.libreoffice.enable = true;
    desktop.vlc.enable = true;
    desktop.multiviewer.enable = true;
    desktop.missioncenter.enable = true;
    desktop.audio.enable = true;
    desktop.wireshark.enable = true;
    desktop.ladybird.enable = true;
    desktop.music.enable = if cfg.enable_extra then true else false;
    desktop.appimage.enable = if cfg.enable_extra then true else false;

    desktop.discord.enable = if cfg.enable_extra then true else false;
    desktop.tradingview.enable = if cfg.enable_extra then true else false;
    desktop.steam.enable = if cfg.enable_games then true else false;
    desktop.obs.enable = if cfg.enable_streaming then true else false;

    home-manager.users.fred = {
      home.file.".config/backgrounds/" = {
        source = ../../dotfiles/fred/.config/backgrounds;
        recursive = true;
      };

      catppuccin.cursors.enable = true;
    };
  };
}
