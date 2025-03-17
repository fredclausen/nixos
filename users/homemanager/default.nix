{ pkgs, lib, ... }:
let
  username = "fred";
in
with lib.hm.gvariant;
{
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = false;
    };

    mimeApps = {
      enable = true;

      associations.added = {
        "text/html" = [ "firefox.desktop" ];
        "text/plain" = [ "sublime_text.desktop" ];
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
        "x-scheme-handler/about" = [ "firefox.desktop" ];
        "x-scheme-handler/unknown" = [ "firefox.desktop" ];
        "x-terminal-emulator" = [ "ghostty.desktop" ];
        "image/bmp" = [ "org.gnome.gThumb.desktop" ];
        "image/jpeg" = [ "org.gnome.gThumb.desktop" ];
        "image/gif" = [ "org.gnome.gThumb.desktop" ];
        "image/png" = [ "org.gnome.gThumb.desktop" ];
        "image/tiff" = [ "org.gnome.gThumb.desktop" ];
        "image/x-bmp" = [ "org.gnome.gThumb.desktop" ];
        "image/x-ico" = [ "org.gnome.gThumb.desktop" ];
        "image/x-png" = [ "org.gnome.gThumb.desktop" ];
        "image/x-pcx" = [ "org.gnome.gThumb.desktop" ];
        "image/x-tga" = [ "org.gnome.gThumb.desktop" ];
        "image/xpm" = [ "org.gnome.gThumb.desktop" ];
        "image/svg+xml" = [ "org.gnome.gThumb.desktop" ];
        "image/webp" = [ "org.gnome.gThumb.desktop" ];
        "image/jxl" = [ "org.gnome.gThumb.desktop" ];
        "application/x-zerosize" = [ "sublime_text.desktop" ];
      };
      defaultApplications = {
        "text/html" = [ "firefox.desktop" ];
        "text/plain" = [ "sublime_text.desktop" ];
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
        "x-scheme-handler/about" = [ "firefox.desktop" ];
        "x-scheme-handler/unknown" = [ "firefox.desktop" ];
        "x-terminal-emulator" = [ "ghostty.desktop" ];
        "image/bmp" = [ "org.gnome.gThumb.desktop" ];
        "image/jpeg" = [ "org.gnome.gThumb.desktop" ];
        "image/gif" = [ "org.gnome.gThumb.desktop" ];
        "image/png" = [ "org.gnome.gThumb.desktop" ];
        "image/tiff" = [ "org.gnome.gThumb.desktop" ];
        "image/x-bmp" = [ "org.gnome.gThumb.desktop" ];
        "image/x-ico" = [ "org.gnome.gThumb.desktop" ];
        "image/x-png" = [ "org.gnome.gThumb.desktop" ];
        "image/x-pcx" = [ "org.gnome.gThumb.desktop" ];
        "image/x-tga" = [ "org.gnome.gThumb.desktop" ];
        "image/xpm" = [ "org.gnome.gThumb.desktop" ];
        "image/svg+xml" = [ "org.gnome.gThumb.desktop" ];
        "image/webp" = [ "org.gnome.gThumb.desktop" ];
        "image/jxl" = [ "org.gnome.gThumb.desktop" ];
        "application/x-zerosize" = [ "sublime_text.desktop" ];
      };
    };
  };

  dconf.settings = {
    # ...
    "org/gnome/shell" = {
      disable-user-extensions = false;
      always-show-log-out = true;

      # `gnome-extensions list` for a list
      enabled-extensions = [
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "Vitals@CoreCoding.com"
        "arcmenu@arcmenu.com"
        "caffeine@patapon.info"
        "clipboard-indicator@tudmotu.com"
        "dash-to-panel@jderose9.github.com"
        "impatience@gfxmonk.net"
        "search-light@icedman.github.com"
        "weatherornot@somepaulo.github.io"
      ];

      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "org.gnome.Calendar.desktop"
        "org.gnome.Geary.desktop"
        "discord.desktop"
        "code.desktop"
        "com.mitchellh.ghostty.desktop"
        "firefox.desktop"
      ];
    };

    "org.gnome.desktop.default-applications.terminal" = {
      exec = "ghostty";
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
      clock-show-seconds = true;
      clock-show-weekday = true;
      clock-format = "24h";
    };

    "org.gnome.desktop.calendar" = {
      show-weekdate = true;
    };

    "org/gnome/shell/extensions/user-theme" = {
      name = "Flat-Remix-Grey-Dark";
    };

    "org/gnome/shell/extensions/arcmenu" = {
      menu-button-appears = "Icon";
      menu-layout = "Plasma";
    };

    "org/gnome/desktop/background" = {
      picture-uri = "file:///home/fred/GitHub/fred-config/lewis.jpg";
      picture-uri-dark = "file:///home/fred/GitHub/fred-config/lewis.jpg"; # Updated dark background...same as light for now
    };

    "org/gnome/shell/extensions/dash-to-panel" = {
      trans-panel-opacity = 0.5;
      trans-use-custom-panel-opacity = true;
      panel-element-positions = ''
        {"0":[{"element":"showAppsButton","visible":false,"position":"stackedTL"},{"element":"activitiesButton","visible":false,"position":"stackedTL"},{"element":"leftBox","visible":true,"position":"stackedTL"},{"element":"taskbar","visible":true,"position":"stackedTL"},{"element":"centerBox","visible":true,"position":"stackedBR"},{"element":"rightBox","visible":true,"position":"stackedBR"},{"element":"dateMenu","visible":true,"position":"stackedBR"},{"element":"systemMenu","visible":true,"position":"stackedBR"},{"element":"desktopButton","visible":true,"position":"stackedBR"},{"element":"new-element","visible":true,"position":"stackedBR"}]}
      '';
    };

    "org/gnome/shell/extensions/weatherornot" = {
      position = "clock-right";
    };

    "org/gnome/shell/extensions/search-light" = {
      shortcut-search = [ "<Control>Space" ];
    };

    "org/gnome/shell/weather" = {
      automatic-location = true;
      locations = [
        (mkVariant (mkTuple [
          (mkUint32 2)
          (mkVariant (mkTuple [
            "Albuquerque"
            "KABQ"
            true
            [
              (mkTuple [
                (mkDouble "0.6115924645374438")
                (mkDouble "-1.8607779299984337")
              ])
            ]
            [
              (mkTuple [
                (mkDouble "0.6123398843363179")
                (mkDouble "-1.8614134916455476")
              ])
            ]
          ]))
        ]))
        (mkVariant (mkTuple [
          (mkUint32 2)
          (mkVariant (mkTuple [
            "Albuquerque International Airport"
            "KABQ"
            false
            [
              (mkTuple [
                (mkDouble "0.6115924645374438")
                (mkDouble "-1.8607779299984337")
              ])
            ]
            (mkArray "(dd)" [ ])
          ]))
        ]))
      ];
    };

    "org/gnome/Weather" = {
      locations = [
        (mkVariant (mkTuple [
          (mkUint32 2)
          (mkVariant (mkTuple [
            "Albuquerque"
            "KABQ"
            true
            [
              (mkTuple [
                (mkDouble "0.6115924645374438")
                (mkDouble "-1.8607779299984337")
              ])
            ]
            [
              (mkTuple [
                (mkDouble "0.6123398843363179")
                (mkDouble "-1.8614134916455476")
              ])
            ]
          ]))
        ]))
        (mkVariant (mkTuple [
          (mkUint32 2)
          (mkVariant (mkTuple [
            "Albuquerque International Airport"
            "KABQ"
            false
            [
              (mkTuple [
                (mkDouble "0.6115924645374438")
                (mkDouble "-1.8607779299984337")
              ])
            ]
            (mkArray "(dd)" [ ])
          ]))
        ]))
      ];
    };

    "org/gnome/GWeather4" = {
      temperature-unit = "centigrade";
    };
  };

  # programs.git = {
  #   enable = true;
  #   userName = "Fred Clausen";
  #   userEmail = "fredclausen@users.noreply.github.com";
  #   signing = {
  #     gpgPath = "/run/current-system/sw/bin/gpg";
  #     signByDefault = true;
  #     key = "F406B080289FEC21";
  #   };
  #   lfs = {
  #     enable = true;
  #     skipSmudge = true;
  #   };
  # };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    history.size = 10000;

    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;

    shellAliases = {
      ls = "lsd -l";
      lsa = "lsd -la";
      co = "rustup update";
      ng = "nvim ~/GitHub";
      ngs = "nvim ~/Github/sdre-hub";
      ngf = "nvim ~/GitHub/freminal";
      ngc = "nvim_custom";
      na = "nvim ~/GitHub/docker-acarshub";
      n = "nvim";
      cat = "bat --color always";
    };

    initExtra = ''
      show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

      export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
      export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"
      eval "$(pay-respects zsh --alias)"

      alias gc="gcverify";
      alias gcn="gcnoverify";
      alias gp="gpfred";
      alias rds="remove_dsstore";

      if [ -d /home/fred/ ]; then
        alias uz="~/GitHub/fred-config/update-zsh-stuff.sh"
        alias ugh="~/GitHub/fred-config/update-all-git.sh ~/GitHub"
        alias ipc="~/GitHub/fred-config/install-all-precommit.sh ~/GitHub"
        alias scr="~/GitHub/fred-config/sync-compose.sh"
        alias ub="~/GitHub/fred-config/update-brew.sh"
      elif [ -d /Users/fred ]; then
        alias uz="~/GitHub/fred-config/update-zsh-stuff.sh"
        alias ugh="~/GitHub/fred-config/update-all-git.sh ~/GitHub"
        alias ipc="~/GitHub/fred-config/install-all-precommit.sh ~/GitHub"
        alias scr="~/GitHub/fred-config/sync-compose.sh"
        alias ub="~/GitHub/fred-config/update-brew.sh"
      fi

      function nvim_custom () {
        if [ -z "$1" ]; then
          echo "Please provide a file to edit"
          return
        fi

        if [ -d /home/fred/ ]; then
          nvim ~/GitHub/$1
        elif [ -d /Users/fred ]; then
          nvim ~/GitHub/$1
        else
          echo "No user directory found"
        fi
      }

      function remove_dsstore() {
        if [ -d /home/fred/ ]; then
          pushd /home/fred/GitHub/$1 1> /dev/null
        elif [ -d /Users/fred ]; then
          pushd /Users/fred/GitHub/$1 1> /dev/null
        else
          echo "No user directory found"
          return
        fi

        # now find the script for removing .DS_Store files

        if [ -f ~/GitHub/fred-config/remove_dsstore.sh ]; then
          ~/GitHub/fred-config/remove_dsstore.sh
        elif [ -f ~/GitHub/fred/remove_dsstore.sh ]; then
          ~/GitHub/fred/fred-config/remove_dsstore.sh
        else
          echo "No script found"
        fi

        popd 1> /dev/null
      }

      function gpfred() {
        sign
        if [ -d /home/fred/ ]; then
          pushd /home/fred/GitHub/$1 1> /dev/null
        elif [ -d /Users/fred ]; then
          pushd /Users/fred/GitHub/$1 1> /dev/null
        else
          echo "No user directory found"
          return
        fi

        git push
        popd 1> /dev/null
      }

      function ua() {
        echo "Updating all"
        # if we're on linux, we want to update oh-my-posh
        if !command -v nixos-rebuild &> /dev/null; then
          if [ -d /home/fred/ ]; then
            echo "Updating oh-my-posh...."
            curl -s https://ohmyposh.dev/install.sh | bash -s
          fi
        else
          echo "NixOS detected, skipping oh-my-posh update"
        fi

        # if .skipcargo exists, don't update cargo
        if [ -f ~/.skipcargo ]; then
          echo "Skipping cargo update"
        else
          echo "Updating cargo...."
          co
          cargo install-update -a
        fi
        echo "Updating ZSH...."
        uz
        echo "Updating Git...."
        ugh
        echo "Installing pre-commit hooks...."
        ipc
        echo "Updating brew...."
        ub
        # if bob command exists, AND ~/.local/share/bob exists, update bob
        if command -v bob &> /dev/null && [ -d ~/.local/share/bob ]; then
          echo "Updating bob...."
          bob update
        fi
      }

      function scar() {
        echo "Syncing all compose file (remote to local)...."
        scr remote all
      }

      function scal() {
        echo "Syncing all compose files (local to remote)...."
        scr local all
      }

      function sign() {
        mkdir -p ~/tmp/
        pushd ~/tmp/ 1> /dev/null
        touch a.txt
        gpg --sign a.txt
        popd 1> /dev/null
        rm -rf ~/tmp/
      }

      function gcverify() {
        # verify $1 and $2 exist
        if [ -z "$2" ]; then
          echo "Please provide a commit message"
          return
        fi

        sign
        if [ -d /home/fred/ ]; then
          pushd /home/fred/GitHub/$1 1> /dev/null
        elif [ -d /Users/fred ]; then
          pushd /Users/fred/GitHub/$1 1> /dev/null
        else
          echo "No user directory found"
          return
        fi
        git add .
        gcam $2
        popd 1> /dev/null
      }

      function gcnoverify() {
        # verify $1 and $2 exist
        if [ -z "$2" ]; then
          echo "Please provide a commit message"
          return
        fi

        sign

        if [ -d /home/fred/ ]; then
          pushd /home/fred/GitHub/$1 1> /dev/null
        elif [ -d /Users/fred ]; then
          pushd /Users/fred/GitHub/$1 1> /dev/null
        else
          echo "No user directory found"
          return
        fi
        git add .
        git commit --all --no-verify -m $2
        popd 1> /dev/null
      }
      fastfetch -c paleofetch.jsonc
    '';
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

  programs.ghostty = {
    enable = true;

    settings = {
      font-family = "MesloLGS Nerd Font Mono";
      font-size = 10;
      theme = "Wez";
    };
  };

  programs.wezterm = {
    enable = true;

    extraConfig = ''
      -- Pull in the wezterm API
      local wezterm = require("wezterm")

      -- This will hold the configuration.
      local config = wezterm.config_builder()
      local mux = wezterm.mux

      -- This is where you actually apply your config choices

      config.font = wezterm.font("MesloLGS Nerd Font Mono")
      config.font_size = 10
      config.enable_wayland = false

      local act = wezterm.action
      config.keys = {
        { mods = "OPT", key = "LeftArrow", action = act.SendKey({ mods = "ALT", key = "b" }) },
        { mods = "OPT", key = "RightArrow", action = act.SendKey({ mods = "ALT", key = "f" }) },
        { mods = "CMD", key = "LeftArrow", action = act.SendKey({ mods = "CTRL", key = "a" }) },
        { mods = "CMD", key = "RightArrow", action = act.SendKey({ mods = "CTRL", key = "e" }) },
        { mods = "CMD", key = "Backspace", action = act.SendKey({ mods = "CTRL", key = "u" }) },
        { mods = "CMD|OPT", key = "LeftArrow", action = act.ActivateTabRelative(-1) },
        { mods = "CMD|OPT", key = "RightArrow", action = act.ActivateTabRelative(1) },
        { mods = "CMD|SHIFT", key = "LeftArrow", action = act.ActivateTabRelative(-1) },
        { mods = "CMD|SHIFT", key = "RightArrow", action = act.ActivateTabRelative(1) },
      }

      return config

      -- 1512x854
    '';
  };

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    stateVersion = "24.11";

    packages = with pkgs; [
      zoxide
    ];
  };
}
