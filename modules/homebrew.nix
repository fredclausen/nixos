{ pkgs, user, ... }:
{

  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    taps = [
      "pothosware/pothos"
    ];

    brews = [
      "gcc"
      "telnet"
      "vttest"
      "trunk"
      "cargo-make"
      "diesel"
    ];

    casks = [
      "ghostty"
      "vlc"
      "iterm2"
      "raycast"
      "visual-studio-code"
      "visual-studio"
      "hiddenbar"
      "sublime-text"
      "tradingview"
      "macupdater"
      "istat-menus"
      "github"
      "discord"
      "docker-desktop"
      "brave-browser"
      "balenaetcher"
      "streamlabs"
      "ledger-wallet"
      "elgato-stream-deck"
      "db-browser-for-sqlite"
      "angry-ip-scanner"
      "font-fira-code"
      "font-hack-nerd-font"
      "font-meslo-lg-nerd-font"
      "multiviewer"
      "mono-mdk-for-visual-studio"
    ];
  };
}
