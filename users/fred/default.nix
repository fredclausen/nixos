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
        oh-my-posh
        stow
        zoxide
        pay-respects
        lazygit
        yazi
        rtl-sdr-librtlsdr
        rrdtool
        dconf2nix
      ];
    };
  };
}
