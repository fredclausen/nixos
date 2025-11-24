{
  config,
  pkgs,
  lib,
  inputs,
  user,
  ...
}:

let
  username = user;
in

{
  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "24.11";

    packages = with pkgs; [
      zoxide
      oh-my-zsh
    ];
  };

  xdg = {
    enable = true;

    userDirs = {
      enable = true;
      createDirectories = false;
    };

    mimeApps.enable = true;
  };

  fonts.fontconfig.enable = true;

  imports = [
    # full HM suite
    ../../users/homemanager/default.nix
    inputs.catppuccin.homeModules.catppuccin
    inputs.nixvim.homeModules.nixvim
    inputs.niri.homeModules.niri
  ];

  # dotfiles that every host shares
  home.file.".gitconfig".source = ../../dotfiles/${user}/.gitconfig;

  programs.wezterm.extraConfig = builtins.readFile ../../dotfiles/${user}/.wezterm.lua;

  programs.alacritty.settings = builtins.fromTOML (
    builtins.readFile ../../dotfiles/${user}/.config/alacritty.toml
  );
}
