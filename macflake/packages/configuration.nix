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
  };
}
