{ config, pkgs, ... }:
{
  config = {
    users.users.fred = {
      packages = with pkgs; [
        wezterm
        ghostty
      ];
    };
  };
}
