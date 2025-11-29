{
  stateVersion,
  user,
  homeDir,
  pkgs,
  ...
}:
let
  username = user;
  homeDir = "/home/${username}";
in
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

  system.activationScripts.detectRebootRequired = {
    text = ''
      readlink=${pkgs.coreutils}/bin/readlink
      touch=${pkgs.coreutils}/bin/touch
      rm=${pkgs.coreutils}/bin/rm

      booted="$($readlink /run/booted-system/kernel)"
      current="$($readlink /run/current-system/kernel)"

      if [ "$booted" != "$current" ]; then
        echo "Kernel changed; reboot required"
        $touch /run/reboot-required
      else
        $rm -f /run/reboot-required
      fi
    '';
    postActivation = true;
  };

}
