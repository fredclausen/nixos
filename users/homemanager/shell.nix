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
    settings = {
      add_newline = false;
      right_format = "$cmd_duration $time";
      format = "$username$hostname$directory$git_branch$git_commit$git_state$git_metrics$git_status$line_break[└─](bold white)$jobs$battery$status$character";

      time = {
        disabled = false;
        style = "#ffffff";
        format = "[$time](bold $style)";
      };

      cmd_duration = {
        style = "#ffffff";
        format = "[$duration](bold bg:black fg:white)";
      };

      #format = "$crystal$golang$java$nodejs$php$python$rust$directory$git_branch$git_commit$git_state$git_status$character";
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };

      hostname = {
        ssh_only = false;
        style = "#73a942";
        format = "[$hostname](bold fg:black bg:$style)[](fg:#73a942 bg:#9863ba)";
      };

      username = {
        style_user = "#73a942";
        style_root = "#C00311";
        format = "[](fg:black bg:$style)[$user](bold fg:black bg:$style)[@](bold fg:black bg:$style)";
        show_always = true;
      };

      directory = {
        disabled = false;
        style = "#9863ba";
        format = "[](bg:#9863ba fg:$style)[$path[$read_only](bold bg:$style fg:white)](bold bg:$style fg:white)[](fg:$style)";
        read_only = " ";
        truncate_to_repo = false;
      };

      git_branch = {
        style = "#73a942";
        format = "[](fg:black bg:$style)[ $symbol$branch](bold fg:black bg:$style)[](fg:$style)";
      };

      git_commit = {
        style = "#73a942";
        format = "[](fg:black bg:$style)[\\($hash$tag\\)](bold fg:black bg:$style)[](fg:$style)";
      };

      git_state = {
        style = "#73a942";
        format = "[[](fg:black bg:$style))[ \\($state( $progress_current/$progress_total)\\)](bold fg:black bg:$style)[](fg:$style)";
      };

      git_status = {
        style = "#73a942";
        format = "([](bg:$style fg:black)$conflicted$staged$modified$renamed$deleted$untracked$stashed$ahead_behind[](fg:$style))";
        conflicted = "[ ](bold fg:88 bg:#73a942)[  $count ](bold fg:black bg:#73a942)";
        staged = "[ $count ](bold fg:black bg:#73a942)";
        modified = "[🌓︎ $count ](bold fg:black bg:#73a942)";
        renamed = "[ $count ](bold fg:black bg:#73a942)";
        deleted = "[ $count ](bold fg:black bg:#73a942)";
        untracked = "[?$count ](bold fg:black bg:#73a942)";
        stashed = "[ $count ](bold fg:black bg:#73a942)";
        ahead = "[ $count ](bold fg:#523333 bg:#73a942)";
        behind = "[ $count ](bold fg:black bg:#73a942)";
        diverged = "[ ](bold fg:88 bg:#73a942)[ נּ ](bold fg:black bg:#73a942)[ $ahead_count ](bold fg:#73a942)[ $behind_count ](bold fg:#73a942)";
      };
    };
  };

  # FIXME: Pay respects needs to be configured here when upstreamed https://github.com/nix-community/home-manager/issues/6204

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
