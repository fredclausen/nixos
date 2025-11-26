{
  ##########################################################################
  ## HOME BASE SETTINGS (platform-aware)
  ##########################################################################
  home = {
    username = username;
    homeDirectory = homeDir;
    stateVersion = stateVersion;

    packages = with pkgs; [
      zoxide
      oh-my-zsh
    ];
  };

  ##########################################################################
  ## XDG + FONTS — Linux Only
  ##########################################################################
  xdg.enable = true;

  xdg.userDirs = {
    enable = true;
    createDirectories = false;
  };

  xdg.mimeApps.enable = true;

  fonts.fontconfig.enable = true;
}
