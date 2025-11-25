{
  config,
  pkgs,
  lib,
  inputs,
  user,
  verbose_name,
  github_email,
  github_signing_key,
  ...
}:

let
  username = user;
  isDarwin = pkgs.stdenv.isDarwin;

  weztermConfig =
    if isDarwin then ../../dotfiles/fred/.wezterm_darwin.lua else ../../dotfiles/fred/.wezterm.lua;

  alacrittyConfig =
    if isDarwin then
      ../../dotfiles/fred/.config/alacritty_darwin.toml
    else
      ../../dotfiles/fred/.config/alacritty.toml;
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

  home.file.".gitconfig".text = ''
    [filter "lfs"]
            required = true
            clean = git-lfs clean -- %f
            smudge = git-lfs smudge -- %f
            process = git-lfs filter-process

    [user]
            name = ${verbose_name}
            email = ${github_email}
            signingkey = ${github_signing_key}

    [commit]
            gpgsign = true

    [gpg]
      program = /run/current-system/sw/bin/gpg

    [core]
        pager = delta

    [interactive]
        diffFilter = delta --color-only

    [delta]
        navigate = true
        side-by-side = true

    [merge]
        conflictstyle = diff3

    [diff]
        colorMoved = default
  '';

  programs.wezterm.extraConfig = builtins.readFile weztermConfig;

  programs.alacritty.settings = builtins.fromTOML (builtins.readFile alacrittyConfig);
}
