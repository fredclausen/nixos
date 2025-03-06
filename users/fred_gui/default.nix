{ config, pkgs, ... }:
{
  config = {
    users.users.fred = {
      packages = with pkgs; [
        github-desktop
        vscode
        wezterm
        brave
        _1password-gui
        ghostty
        sublime4
      ];
    };
  };
}
