# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.home-manager.darwinModules.default
    ../../packages/shell
    ../../packages/develop/ansible
    ../../packages/develop/clang
    ../../packages/develop/hadolint
    ../../packages/develop/make
    ../../packages/develop/ninja
    ../../packages/develop/node
    ../../packages/develop/pre-commit
    ../../packages/develop/nvim
    ../../packages/develop/python
    ../../packages/develop/rust
    ../../packages/develop/shellcheck
    ../../packages/develop/typos
    ../../packages/common/btop
    ../../packages/common/git
    ../../packages/desktop/alacritty
    ../../packages/desktop/githubdesktop
    ../../packages/desktop/ghostty
    ../../packages/desktop/wezterm
  ];

  config = {
    desktop.wezterm.enable = true;
    desktop.alacritty.enable = true;
    home-manager.users.fred =
      { config, pkgs, ... }:
      {
        home.file."./.config/nvim".source =
          config.lib.file.mkOutOfStoreSymlink "/Users/fred/GitHub/nixos/dotfiles/fred/.config/nvim";
        programs.wezterm = {
          extraConfig = builtins.readFile ../../dotfiles/fred/.wezterm_darwin.lua;
        };
        programs.alacritty = {
          settings = (
            builtins.fromTOML (builtins.readFile ../../dotfiles/fred/.config/alacritty_darwin.toml)
          );
        };
      };
    fonts = {
      packages = with pkgs; [
        cascadia-code
        nerd-fonts.caskaydia-mono
        nerd-fonts.caskaydia-cove
      ];
    };
  };
}
