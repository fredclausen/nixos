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
          ls = lib.mkForce "${pkgs.lsd}/bin/lsd -la";
        };

        initContent = ''
          # --- Auto-start tmux ---
          if [[ -z "$TMUX" && -n "$PS1" ]]; then
            exec tmux new-session -A -s main
          fi
          # --- Your aliases file ---
          ${(builtins.readFile ../../../dotfiles/fred/.oh-my-zsh/custom/aliases.zsh)}
        '';
      };

      catppuccin.zsh-syntax-highlighting.enable = true;
    };
  };
}
