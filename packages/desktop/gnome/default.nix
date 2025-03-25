{
  lib,
  pkgs,
  config,
  hmlib,
  ...
}:
with lib;
let
  cfg = config.desktop.gnome;
in
{
  options.desktop.gnome = {
    enable = mkOption {
      description = "Install GNOME desktop environment.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.gnomeExtensions.caffeine
      pkgs.gnomeExtensions.vitals
      pkgs.gnomeExtensions.impatience
      pkgs.gnomeExtensions.clipboard-indicator
      pkgs.gnomeExtensions.dash-to-panel
      pkgs.gnomeExtensions.arcmenu
      pkgs.gnomeExtensions.search-light
      pkgs.gnomeExtensions.weather-or-not
      pkgs.flat-remix-gnome
      pkgs.wl-clipboard
      pkgs.dconf-editor
      pkgs.gthumb
      pkgs.gimp
      pkgs.sushi
      pkgs.polkit_gnome
    ];

    programs.nautilus-open-any-terminal = {
      enable = true;
      terminal = "wezterm";
    };

    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the GNOME Desktop Environment.
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;

    environment.gnome.excludePackages = (
      with pkgs;
      [
        atomix # puzzle game
        cheese # webcam tool
        epiphany # web browser
        gnome-characters
        gnome-music
        gnome-photos
        gnome-tour
        hitori # sudoku game
        iagno # go game
        tali # poker game
        totem # video player
      ]
    );

    systemd = {
      user.services.polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = [ "graphical-session.target" ];
        wants = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
      extraConfig = ''
        DefaultTimeoutStopSec=10s
      '';
    };

    home-manager.users.fred.xdg = {
      mimeApps = {
        associations.added = {
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
        };

        defaultApplications = {
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
        };
      };
    };

    home-manager.users.fred.dconf.settings = {
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
          "org.wezfurlong.wezterm.desktop"
          "firefox.desktop"
        ];
      };

      "org.gnome.desktop.default-applications.terminal" = {
        exec = "wezterm";
      };

      "org/gnome/desktop/peripherals/mouse" = {
        speed = hmlib.hm.gvariant.mkDouble "-0.3023255813953488";
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
          (hmlib.hm.gvariant.mkVariant (
            hmlib.hm.gvariant.mkTuple [
              (hmlib.hm.gvariant.mkUint32 2)
              (hmlib.hm.gvariant.mkVariant (
                hmlib.hm.gvariant.mkTuple [
                  "Albuquerque"
                  "KABQ"
                  true
                  [
                    (hmlib.hm.gvariant.mkTuple [
                      (hmlib.hm.gvariant.mkDouble "0.6115924645374438")
                      (hmlib.hm.gvariant.mkDouble "-1.8607779299984337")
                    ])
                  ]
                  [
                    (hmlib.hm.gvariant.mkTuple [
                      (hmlib.hm.gvariant.mkDouble "0.6123398843363179")
                      (hmlib.hm.gvariant.mkDouble "-1.8614134916455476")
                    ])
                  ]
                ]
              ))
            ]
          ))
          (hmlib.hm.gvariant.mkVariant (
            hmlib.hm.gvariant.mkTuple [
              (hmlib.hm.gvariant.mkUint32 2)
              (hmlib.hm.gvariant.mkVariant (
                hmlib.hm.gvariant.mkTuple [
                  "Albuquerque International Airport"
                  "KABQ"
                  false
                  [
                    (hmlib.hm.gvariant.mkTuple [
                      (hmlib.hm.gvariant.mkDouble "0.6115924645374438")
                      (hmlib.hm.gvariant.mkDouble "-1.8607779299984337")
                    ])
                  ]
                  (hmlib.hm.gvariant.mkArray "(dd)" [ ])
                ]
              ))
            ]
          ))
        ];
      };

      "org/gnome/Weather" = {
        locations = [
          (hmlib.hm.gvariant.mkVariant (
            hmlib.hm.gvariant.mkTuple [
              (hmlib.hm.gvariant.mkUint32 2)
              (hmlib.hm.gvariant.mkVariant (
                hmlib.hm.gvariant.mkTuple [
                  "Albuquerque"
                  "KABQ"
                  true
                  [
                    (hmlib.hm.gvariant.mkTuple [
                      (hmlib.hm.gvariant.mkDouble "0.6115924645374438")
                      (hmlib.hm.gvariant.mkDouble "-1.8607779299984337")
                    ])
                  ]
                  [
                    (hmlib.hm.gvariant.mkTuple [
                      (hmlib.hm.gvariant.mkDouble "0.6123398843363179")
                      (hmlib.hm.gvariant.mkDouble "-1.8614134916455476")
                    ])
                  ]
                ]
              ))
            ]
          ))
          (hmlib.hm.gvariant.mkVariant (
            hmlib.hm.gvariant.mkTuple [
              (hmlib.hm.gvariant.mkUint32 2)
              (hmlib.hm.gvariant.mkVariant (
                hmlib.hm.gvariant.mkTuple [
                  "Albuquerque International Airport"
                  "KABQ"
                  false
                  [
                    (hmlib.hm.gvariant.mkTuple [
                      (hmlib.hm.gvariant.mkDouble "0.6115924645374438")
                      (hmlib.hm.gvariant.mkDouble "-1.8607779299984337")
                    ])
                  ]
                  (hmlib.hm.gvariant.mkArray "(dd)" [ ])
                ]
              ))
            ]
          ))
        ];
      };

      "org/gnome/GWeather4" = {
        temperature-unit = "centigrade";
      };
    };
  };
}
