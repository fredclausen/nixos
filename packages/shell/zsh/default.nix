{
  lib,
  pkgs,
  config,
  ...
}:
{
  config = {
    home-manager.users.fred = {
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        history.size = 10000;

        syntaxHighlighting.enable = true;
        autosuggestion.enable = true;

        shellAliases = {
        };

        initExtra = builtins.readFile ../../../dotfiles/fred/.oh-my-zsh/custom/aliases.zsh;
      };
    };
  };
}
