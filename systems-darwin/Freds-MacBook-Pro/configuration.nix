{
  config,
  pkgs,
  lib,
  inputs,
  user,
  hmlib,
  ...
}:
let
  username = user;
in
{
  environment = {
    systemPackages = [ pkgs.coreutils ];
    systemPath = [ "/opt/homebrew/bin" ];
    pathsToLink = [ "/Applications" ];
    variables.EDITOR = "nvim";
  };

  system = {
    primaryUser = "${username}";
    stateVersion = 6;
  };
  security.pam.services.sudo_local.touchIdAuth = true;
  users.users.${username}.home = "/Users/${username}";

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-darwin";

  imports = [
    inputs.home-manager.darwinModules.default
    ../../modules/secrets/sops.nix
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
    ../../packages/desktop/zed
  ];

  desktop.wezterm.enable = true;
  desktop.alacritty.enable = true;
  desktop.zed.enable = true;
  sops_secrets.enable_secrets.enable = true;

  home-manager.users.${username} =
    { config, pkgs, ... }:
    {
      home.packages = with pkgs; [
        wget
        unzip
        file
        lsd
        zip
        toybox
        dig
        jq
        socat
        nmap
        delta
        dateutils
        gnuplot
        cargo-watch
        zeromq
        rrdtool
      ];

      programs.firefox.enable = true;
    };

  fonts = {
    packages = with pkgs; [
      cascadia-code
      nerd-fonts.caskaydia-mono
      nerd-fonts.caskaydia-cove
    ];
  };
}
