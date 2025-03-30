{ config, pkgs, ... }:
{
  config = {
    environment.systemPackages = [
      pkgs.pass
      pkgs.wget
      pkgs.git
      pkgs.unzip
      pkgs.file
      pkgs.lsd
      pkgs.zip
      pkgs.btop
      pkgs.toybox
      pkgs.nix-index
    ];

    xdg.portal = {
      enable = true;
      config.common.default = "*";
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
      persistent = true;
    };
    nix.settings.auto-optimise-store = true;
  };
}
