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
  xdg.enable = lib.mkIf isLinux true;

  xdg.userDirs = lib.mkIf isLinux {
    enable = true;
    createDirectories = false;
  };

  xdg.mimeApps.enable = lib.mkIf isLinux true;

  fonts.fontconfig.enable = lib.mkIf isLinux true;
}
