{ pkgs, ... }:
{
  # here go the darwin preferences and config items
  environment = {
    systemPackages = [ pkgs.coreutils ];
    systemPath = [ "/opt/homebrew/bin" ];
    pathsToLink = [ "/Applications" ];
    variables.EDITOR = "nvim";
  };

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  system = {
    primaryUser = "fred";
    #     keyboard = {
    #       enableKeyMapping = true;
    #       remapCapsLockToEscape = true;
    #     };
    #     defaults = {
    #       finder = {
    #         AppleShowAllExtensions = true;
    #         _FXShowPosixPathInTitle = true;
    #         CreateDesktop = false;
    #         FXPreferredViewStyle = "Nlsv";
    #       };
    #       dock = {
    #         autohide = true;
    #         autohide-delay = 1.0e-2;
    #         autohide-time-modifier = 1.0e-2;
    #         show-recents = false;
    #       };
    #       CustomSystemPreferences = {
    #         NSGlobalDomain = { NSWindowShouldDragOnGesture = true; };
    #       };
    #       NSGlobalDomain = {
    #         "com.apple.sound.beep.feedback" = 0;
    #         "com.apple.sound.beep.volume" = 0.0;
    #         AppleKeyboardUIMode = 3;
    #         ApplePressAndHoldEnabled = false;
    #         InitialKeyRepeat = 15;
    #         KeyRepeat = 2;
    #         AppleShowAllExtensions = true;
    #         NSWindowResizeTime = 0.1;
    #         NSAutomaticWindowAnimationsEnabled = false;
    #       };
    #     };
    stateVersion = 6;
    #     activationScripts = {
    #       postActivation = {
    #         text = "sudo chsh -s ${pkgs.bashInteractive}/bin/bash";
    #       };
    #     };
  };
  security.pam.services.sudo_local.touchIdAuth = true;
  users.users.fred.home = "/Users/fred";
  #   fonts.packages = [ pkgs.nerd-fonts.meslo-lg ];
  #   ids.gids.nixbld = 350;

  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    # use home brew to install packages for spotlight to work
    brews = [
      "gcc"
    ];

    casks = [
      "ghostty"
      "wezterm"
      "vlc"
      "firefox"
      "iterm2"
      "raycast"
      "visual-studio-code"
      "visual-studio"
      "hiddenbar"
      "alacritty"
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
      "ledger-live"
      "elgato-stream-deck"
      "db-browser-for-sqlite"
      "angry-ip-scanner"
      "font-fira-code"
      "font-hack-nerd-font"
      "font-meslo-lg-nerd-font"
    ];
  };
}
