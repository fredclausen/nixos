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
        neovim
        fastfetch
        bat
        gh
        fzf
        oh-my-posh
        stow
        zoxide
        pay-respects
        lsd
        lazygit
        yazi
        pre-commit
        cmake
        lua51Packages.lua
        luajitPackages.luarocks_bootstrap
        tree-sitter
        rtl-sdr-librtlsdr
        rrdtool
        cabal-install
        ghc
      ];
    };
  };
}
