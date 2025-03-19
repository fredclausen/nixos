{ config, pkgs, ... }:
{
  config = {
    users.users.fred = {
      isNormalUser = true;
      description = "Fred Clausen";
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
      ];

      packages = with pkgs; [
        fastfetch
        bat
        gh
        fzf
        fd
        stow
        pay-respects
        rtl-sdr-librtlsdr
        rrdtool
        dconf2nix
        eza
      ];
    };
  };
}
