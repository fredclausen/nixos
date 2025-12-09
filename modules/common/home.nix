{
  lib,
  inputs,
  system,
  verbose_name,
  github_email,
  github_signing_key,
  ...
}:

let
  isDarwin = lib.hasSuffix "darwin" system;
  isLinux = !isDarwin;
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
  ++ lib.optional isLinux inputs.niri.homeModules.niri
  ++ lib.optional isLinux ./linux-common.nix;

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
        gpgsign = false

    [gpg]
        program = ${
          if isDarwin then "/run/current-system/sw/bin/gpg" else "/run/current-system/sw/bin/gpg"
        }
        format = ssh

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
