{
  config,
  pkgs,
  lib,
  inputs,
  user,
  system,
  verbose_name,
  github_email,
  github_signing_key,
  stateVersion,
  ...
}:

let
  username = user;
  isDarwin = lib.hasSuffix "darwin" system;
  isLinux = !isDarwin;

  homeDir = if isDarwin then "/Users/${username}" else "/home/${username}";
in
{
  ##########################################################################
  ## Shared Home-Manager module imports
  ##########################################################################
  imports = [
    ../../users/homemanager/default.nix
    inputs.catppuccin.homeModules.catppuccin
    inputs.nixvim.homeModules.nixvim
  ]
  ++ lib.optional isLinux inputs.niri.homeModules.niri;

  ##########################################################################
  ## .gitconfig — fully generated
  ##########################################################################
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
        program = ${
          if isDarwin then "/run/current-system/sw/bin/gpg" else "/run/current-system/sw/bin/gpg"
        }

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
}
