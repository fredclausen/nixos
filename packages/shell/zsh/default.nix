{
  lib,
  pkgs,
  user,
  ...
}:
let
  username = user;
  homeDir =
    if pkgs.stdenv.isDarwin then
      "/Users/${username}/.oh-my-zsh/custom"
    else
      "/home/${username}/.oh-my-zsh/custom";
in
{
  config = {
    home-manager.users.${username} = {
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        history.size = 10000;

        syntaxHighlighting.enable = true;
        autosuggestion.enable = true;

        # Example override
        shellAliases = {
          ls = lib.mkForce "${pkgs.lsd}/bin/lsd -la";
        };

        # Instead of initContent, use initExtra so we can source files
        initContent = lib.mkMerge [
          # EARLY INIT – env, paths
          (lib.mkOrder 500 ''
            source ${homeDir}/00-env.zsh
          '')

          # TMUX must come before OMZ
          (lib.mkOrder 900 ''
            source ${homeDir}/15-tmux.zsh
          '')

          # ZLE before completion
          (lib.mkOrder 550 ''
            source ${homeDir}/20-zle.zsh
          '')

          # MAIN CONFIG – aliases, fzf, functions
          (lib.mkOrder 1000 ''
            source ${homeDir}/10-aliases.zsh
            source ${homeDir}/30-fzf.zsh
            source ${homeDir}/40-functions.zsh
          '')

          # FINAL
          (lib.mkOrder 1500 ''
            source ${homeDir}/90-final.zsh
          '')
        ];

      };

      # zsh-syntax-highlighting theme
      catppuccin.zsh-syntax-highlighting.enable = true;

      # Install your custom Zsh module files
      home.file.".oh-my-zsh/custom".source = ../../../dotfiles/.oh-my-zsh/custom;
    };
  };
}
