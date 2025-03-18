{ config, pkgs, ... }:
{
  config = {
    users.users.fred = {
      packages = with pkgs; [
        github-desktop
        vscode
        wezterm
        _1password-gui
        ghostty
        sublime4
        sqlitebrowser
      ];
    };
  };
}
