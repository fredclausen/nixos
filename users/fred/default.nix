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
        github-desktop
        gh
        fzf
        oh-my-posh
        vscode
        stow
        zoxide
        pay-respects
        lsd
        wezterm
        brave
        lazygit
        yazi
        pre-commit
        clang_19
        libgcc
        gcc
        cmake
        _1password-gui
        ghostty
        sublime4
        libGL
        libxkbcommon
        lua51Packages.lua
        luajitPackages.luarocks_bootstrap
        tree-sitter
        rtl-sdr-librtlsdr
        rrdtool
        python3Full
        cabal-install
        ghc
        nodejs_23
      ];
    };
  };
}
