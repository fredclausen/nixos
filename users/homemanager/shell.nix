{ pkgs, lib, ... }:
let
  username = "fred";
in
with lib.hm.gvariant;
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    history.size = 10000;

    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;

    shellAliases = {
    };

    initExtra = builtins.readFile ../../dotfiles/fred/.oh-my-zsh/custom/aliases.zsh;
  };

  # Enable Oh-my-zsh
  programs.zsh.oh-my-zsh = {
    enable = true;
    plugins = [
      "git"
      "history-substring-search"
      "colored-man-pages"
      # "zsh-autosuggestions"
      # "zsh-syntax-highlighting"
      "sudo"
      "copyfile"
      "copybuffer"
      "history"
      "zoxide"
    ];
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [
      "--cmd cd"
    ];
  };

  programs.starship = {
    enable = true;
    settings = (builtins.fromTOML (builtins.readFile ../../dotfiles/fred/.config/starship.toml));
  };

  # FIXME: Pay respects needs to be configured here when upstreamed https://github.com/nix-community/home-manager/issues/6204

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
