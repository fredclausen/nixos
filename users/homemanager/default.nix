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
      right_format = "$cmd_duration $time";
      format = "$username$hostname$directory$git_branch$git_commit$git_state$git_metrics$git_status$c$cmake$java$lua$nodejs$python$rust$zig$nix_shell$sudo$line_break[└─](bold white)$jobs$battery$status$character";

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
        format = "[](fg:black bg:$style)[$hostname](bold fg:black bg:$style)[](fg:$style)";
      };

      username = {
        style_user = "#73a942";
        style_root = "#C00311";
        format = "[](fg:black bg:$style)[$user](bold fg:black bg:$style)[](fg:$style)";
        show_always = true;
      };

      directory = {
        disabled = false;
        style = "#9863ba";
        format = "[](fg:black bg:$style)[$path[$read_only](bold bg:$style fg:black)](bold bg:$style fg:white)[](fg:$style)";
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

      # Language Support
      golang = {
        style = "bold fg:black bg:#73a942";
        format = "[](fg:black bg:#73a942)[$symbol$version]($style)[](fg:#73a942)";
      };

      java = {
        style = "bold fg:black bg:#73a942";
        format = "[](fg:black bg:#73a942)[$symbol$version]($style)[](fg:#73a942)";
      };

      php = {
        style = "bold fg:black bg:#73a942";
        format = "[](fg:black bg:#73a942)[$symbol$version]($style)[](fg:#73a942)";
      };

      python = {
        style = " bold fg:black bg:#73a942";
        format = "[](fg:black bg:#73a942)[$symbol$pyenv_prefix$version$virtualenv]($style)[](fg:#73a942)";
      };

      package = {
        disabled = true;
      };

      rust = {
        style = "bold fg:black bg:#73a942";
        format = "[](fg:black bg:#73a942)[$symbol$version]($style)[](fg:#73a942)";
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
