{
  pkgs,
  lib,
  user,
  ...
}:
let
  username = user;
in
with lib.hm.gvariant;
{
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = false;
    };

    mimeApps = {
      enable = true;
    };
  };

  fonts.fontconfig.enable = true;

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    stateVersion = "24.11";

    packages = with pkgs; [
      zoxide
      oh-my-zsh
    ];
  };
}
