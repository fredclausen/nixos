{ config, pkgs, ... }:
{
  config = {
    environment.systemPackages = [
      pkgs.btop
    ];

    home-manager.users.fred = {
      programs.btop = {
        enable = true;
      };
      catppuccin.btop.enable = true;
    };
  };
}
