{ config, pkgs, ... }:
{
  config = {
    environment.systemPackages = [
      pkgs.pass
      pkgs.wget
      pkgs.git
    ];

    xdg.portal = {
      enable = true;
      config.common.default = "*";
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
  };
}
