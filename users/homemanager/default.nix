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
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      right_format = "$time";

      time = {
        disabled = false;
        style = "#939594";
        format = "[$time]($style)";
      };

      cmd_duration = {
        style = "#f9a600";
        format = "[](fg:black bg:#f9a600)[祥$duration](bg:$style fg:black)[](fg:$style)";
      };

      #format = "$crystal$golang$java$nodejs$php$python$rust$directory$git_branch$git_commit$git_state$git_status$character";
      character = {
        success_symbol = "[ ➤]($bold fg:#f8f8f2)";
        error_symbol = "[ ➤]($bold fg:#fb4934)";
      };

      hostname = {
        ssh_only = false;
        style = "#c05303";
        format = "[](fg:black bg:$style)[$hostname](fg:black bg:$style)[](fg:$style)";
      };

      username = {
        style_user = "#0370C0";
        style_root = "#C00311";
        format = "[](fg:black bg:$style)[$user](fg:black bg:$style)";
        show_always = true;
      };

      directory = {
        disabled = false;
        style = "#c05303";
        format = "[](fg:black bg:#c05303)[$path[$read_only](bg:$style fg:black)](bg:$style fg:black)[](fg:$style)";
        read_only = " ";
        truncate_to_repo = false;
      };

      git_branch = {
        style = "#d8712c";
        format = "[](fg:black bg:$style)[ $symbol$branch](fg:black bg:$style)[](fg:$style)";
      };

      git_commit = {
        style = "#d8712c";
        format = "[](fg:black bg:$style)[\\($hash$tag\\)](fg:black bg:$style)[](fg:$style)";
      };

      git_state = {
        style = "#d8712c";
        format = "[[](fg:black bg:$style))[ \\($state( $progress_current/$progress_total)\\)](fg:black bg:$style)[](fg:$style)";
      };

      git_status = {
        style = "#d8712c";
        format = "([](bg:$style fg:black)$conflicted$staged$modified$renamed$deleted$untracked$stashed$ahead_behind[](fg:$style))";
        conflicted = "[ ](bold fg:88 bg:#d8712c)[  $count ](fg:black bg:#d8712c)";
        staged = "[ $count ](fg:black bg:#d8712c)";
        modified = "[🌓︎ $count ](fg:black bg:#d8712c)";
        renamed = "[ $count ](fg:black bg:#d8712c)";
        deleted = "[ $count ](fg:black bg:#d8712c)";
        untracked = "[?$count ](fg:black bg:#d8712c)";
        stashed = "[ $count ](fg:black bg:#d8712c)";
        ahead = "[ $count ](fg:#523333 bg:#d8712c)";
        behind = "[ $count ](fg:black bg:#d8712c)";
        diverged = "[ ](fg:88 bg:#d8712c)[ נּ ](fg:black bg:#d8712c)[ $ahead_count ](fg:black bg:#d8712c)[ $behind_count ](fg:black bg:#d8712c)";
      };

      shell = {
        fish_indicator = "";
        bash_indicator = "bash ";
        zsh_indicator = "zsh ";
        powershell_indicator = "";
        format = "[$indicator](fg:#ad4007)";
        disabled = false;
      };
      shlvl = {
        symbol = " ";
        style = "fg:black bg:#ad4007";
        format = "[](fg:black bg:#ad4007)[$symbol$shlvl]($style)[](fg:#ad4007)";
        disabled = false;
      };

      # Language Support
      crystal = {
        format = "🔮 ";
      };

      golang = {
        format = "🐭 ";
      };

      java = {
        format = "🍵 ";
      };

      php = {
        format = "🐘 ";
      };

      python = {
        style = "fg:black bg:#eb9606";
        format = "[](fg:black bg:#eb9606)[$symbol$pyenv_prefix$version$virtualenv]($style)[](fg:#eb9606)";
      };

      package = {
        disabled = true;
      };

      rust = {
        style = "fg:black bg:#eb9606";
        format = "[](fg:black bg:#eb9606)[$symbol$version]($style)[](fg:#eb9606)";
      };
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    stateVersion = "24.11";

    packages = with pkgs; [
    ];
  };
}
