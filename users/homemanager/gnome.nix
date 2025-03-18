{ pkgs, lib, ... }:
let
  username = "fred";
in
with lib.hm.gvariant;
{
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
}
