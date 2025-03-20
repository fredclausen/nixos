{
  lib,
  pkgs,
  config,
  hmlib,
  ...
}:
with lib;
let
  cfg = config.desktop.hyprland;
in
{
  options.desktop.hyprland = {
    enable = mkOption {
      description = "Install Hyprland desktop environment.";
      default = false;
    };
  };

  imports = [
    ./modules
  ];

  config = mkIf cfg.enable {
    desktop.hyprland.modules.enable = true;

    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the GNOME Desktop Environment.
    services.xserver.displayManager.gdm.enable = true;

    users.users.fred = {
      packages = with pkgs; [
        hyprpolkitagent

        grim
        slurp
        swaybg
        wlogout
        networkmanagerapplet
      ];
    };

    programs.hyprland = {
      # Install the packages from nixpkgs
      enable = true;
      # Whether to enable XWayland
      xwayland.enable = true;
    };

    home-manager.users.fred = {
      programs.fuzzel = {
        enable = true;
        settings = {
          colors = {
            background = "282a36dd";
            text = "f8f8f2ff";
            match = "8be9fdff";
            selection-match = "8be9fdff";
            selection = "44475add";
            selection-text = "f8f8f2ff";
            border = "bd93f9ff";
          };
        };
      };

      programs.waybar = {
        enable = true;

        settings = {
          "mainBar" = {
            "layer" = "top";
            "position" = "top";
            "height" = 24;
            "spacing" = 4;

            "modules-left" = [
              "hyprland/workspaces"
              "wlr/taskbar"
            ];

            "modules-center" = [
              "hyprland/window"
            ];

            "modules-right" = [
              "tray"
              "battery"
              "pulseaudio"
              "clock"
              "custom/power"
            ];

            "wlr/taskbar" = {
              "on-click" = "activate";
              "on-click-middle" = "close";
              "ignore-list" = [
                "foot"
              ];
            };

            "hyprland/workspaces" = {
              "format" = "{icon}";
              "all-outputs" = true;
              "on-click" = "activate";
              "on-scroll-up" = "hyprctl dispatch workspace e-1";
              "on-scroll-down" = "hyprctl dispatch workspace e+1";
              # "format-icons" = {
              #   "1" = "";
              #   "2" = "";
              #   "3" = "";
              #   "4" = "";
              #   "5" = "";
              #   "6" = "";
              # };
            };

            "hyprland/window" = {
              "max-length" = 128;
            };

            battery = {
              format = "󰁹 {}%";
            };
            clock = {
              format = " {:%H:%M   %m/%d} ";
              tooltip-format = ''
                <big>{:%Y %B}</big>
                <tt><small>{calendar}</small></tt>'';
            };
            pulseaudio = {
              format = "{icon}   {volume}%";
              tooltip = false;
              format-muted = " Muted";
              on-click = "pamixer -t";
              on-scroll-up = "pamixer -i 5";
              on-scroll-down = "pamixer -d 5";
              scroll-step = 5;
              format-icons = {
                headphone = "";
                hands-free = "";
                headset = "";
                phone = "";
                portable = "";
                car = "";
                default = [
                  ""
                  ""
                  ""
                ];
              };
            };

            "custom/power" = {
              "format" = " ⏻ ";
              "tooltip" = false;
              "on-click" = "wlogout --protocol layer-shell";
            };

            "tray" = {
              "spacing" = 4;
            };
          };
        };

        style = ''
          @define-color background-darker rgba(30, 31, 41, 230);
          @define-color background #282a36;
          @define-color selection #44475a;
          @define-color foreground #f8f8f2;
          @define-color comment #6272a4;
          @define-color cyan #8be9fd;
          @define-color green #50fa7b;
          @define-color orange #ffb86c;
          @define-color pink #ff79c6;
          @define-color purple #bd93f9;
          @define-color red #ff5555;
          @define-color yellow #f1fa8c;
          * {
              border: none;
              border-radius: 0;
              font-family: Iosevka;
              font-size: 11pt;
              min-height: 0;
          }
          window#waybar {
              opacity: 0.9;
              background: @background-darker;
              color: @foreground;
              border-bottom: 2px solid @background;
          }
          #workspaces button {
              padding: 0 10px;
              background: @background;
              color: @foreground;
          }
          #workspaces button:hover {
              box-shadow: inherit;
              text-shadow: inherit;
              background-image: linear-gradient(0deg, @selection, @background-darker);
          }
          #workspaces button.active {
              background-image: linear-gradient(0deg, @purple, @selection);
          }
          #workspaces button.urgent {
              background-image: linear-gradient(0deg, @red, @background-darker);
          }
          #taskbar button.active {
              background-image: linear-gradient(0deg, @selection, @background-darker);
          }
          #clock {
              padding: 0 4px;
              background: @background;
          }
        '';
      };

      wayland.windowManager.hyprland = {
        enable = true;

        settings = {
          "$mainMod" = "SUPER";
          "$fileManager" = "yazi";
          "$terminal" = "ghostty";

          env = [
            "QT_QPA_PLATFORMTHEME,qt6ct"
            "XCURSOR_SIZE, 24"
          ];

          exec = [
            "gsettings set org.gnome.desktop.interface color-scheme \"prefer-dark\""
            "gsettings set org.gnome.desktop.interface gtk-theme \"adw-gtk3\""
          ];

          exec-once = [
            "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 &"
            "waybar"
            "hyprctl setcursor Adwaita 24"
            "swaybg -o \"*\" -i \"/home/fred/GitHub/fred-config/lewis.jpg\" &"
            "nm-applet --indicator"
          ];

          general = {
            "gaps_in" = 2;
            "gaps_out" = 2;
            "col.active_border" = "rgb(44475a) rgb(bd93f9) 90deg";
            "col.inactive_border" = "rgba(44475aaa)";

            "col.nogroup_border_active" = "rgb(bd93f9) rgb(44475a) 90deg";
            no_border_on_floating = false;
            border_size = 2;
          };

          input = {
            kb_layout = "us";
            follow_mouse = 1;
            numlock_by_default = true;
            repeat_delay = 250;
            repeat_rate = 35;

            touchpad = {
              natural_scroll = "yes";
              disable_while_typing = true;
              clickfinger_behavior = true;
              scroll_factor = 0.5;
            };
          };

          gestures = {
            workspace_swipe = true;
            workspace_swipe_distance = 700;
            workspace_swipe_fingers = 4;
            workspace_swipe_cancel_ratio = 0.2;
            workspace_swipe_min_speed_to_force = 5;
            workspace_swipe_direction_lock = true;
            workspace_swipe_direction_lock_threshold = 0;
            workspace_swipe_create_new = true;
          };

          decoration = {
            shadow = {
              enabled = true;
              range = 60;
              offset = "1 2";
              color = "rgba(1E202966)";
              render_power = 3;
              scale = 0.97;
            };
          };

          animations = {
            enabled = "yes";

            bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

            animation = [
              "windows, 1, 7, myBezier"
              "windowsOut, 1, 7, default, popin 80%"
              "border, 1, 10, default"
              "borderangle, 1, 8, default"
              "fade, 1, 7, default"
              "workspaces, 1, 6, default"
            ];
          };

          group = {
            groupbar = {
              "col.active" = "rgb(bd93f9) rgb(44475a) 90deg";
              "col.inactive" = "rgba(282a36dd)";
            };
          };

          binds = {
            scroll_event_delay = 0;
          };

          windowrulev2 = "bordercolor rgb(ff5555),xwayland:1";
          # check if window is xwayland

          bind = [
            "$mainMod, F, exec, firefox"
            "$mainMod, Q, exec, $terminal"
            "$mainMod, E, exec, nautilus"
            "$mainMod, SPACE, exec, fuzzel"
            "$mainMod, C, killactive"
            "$mainMod, M, exit"
            # Move focus with mainMod + arrow keys
            "$mainMod, left, movefocus, l"
            "$mainMod, right, movefocus, r"
            "$mainMod, up, movefocus, u"
            "$mainMod, down, movefocus, d"

            ", Print, exec, grim"
            "$mainMod, Print, exec, grim -g \"$(slurp)\""

            # Switch workspaces with mainMod + [0-9]
            "$mainMod, 1, workspace, 1"
            "$mainMod, 2, workspace, 2"
            "$mainMod, 3, workspace, 3"
            "$mainMod, 4, workspace, 4"
            "$mainMod, 5, workspace, 5"
            "$mainMod, 6, workspace, 6"
            "$mainMod, 7, workspace, 7"
            "$mainMod, 8, workspace, 8"
            "$mainMod, 9, workspace, 9"
            "$mainMod, 0, workspace, 10"

            # Move active window to a workspace with mainMod + SHIFT + [0-9]
            "$mainMod SHIFT, 1, movetoworkspace, 1"
            "$mainMod SHIFT, 2, movetoworkspace, 2"
            "$mainMod SHIFT, 3, movetoworkspace, 3"
            "$mainMod SHIFT, 4, movetoworkspace, 4"
            "$mainMod SHIFT, 5, movetoworkspace, 5"
            "$mainMod SHIFT, 6, movetoworkspace, 6"
            "$mainMod SHIFT, 7, movetoworkspace, 7"
            "$mainMod SHIFT, 8, movetoworkspace, 8"
            "$mainMod SHIFT, 9, movetoworkspace, 9"
            "$mainMod SHIFT, 0, movetoworkspace, 10"

            # Scroll through existing workspaces with mainMod + scroll
            "$mainMod, mouse_down, workspace, e+1"
            "$mainMod, mouse_up, workspace, e-1"

            # Scroll through existing workspaces with mainMod + scroll
            "$mainMod, mouse_down, workspace, e+1"
            "$mainMod, mouse_up, workspace, e-1"
          ];

          bindm = [
            # Move/resize windows with mainMod + LMB/RMB and dragging
            "$mainMod, mouse:272, movewindow"
            "$mainMod, mouse:273, resizewindow"
          ];
        };
      };

      xdg = {
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
    };
  };
}
