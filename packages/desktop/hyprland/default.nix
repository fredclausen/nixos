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
        hyprshot
        slurp
        swaybg
        swayidle
        swaylock
        wev
        playerctl
        libnotify
        brightnessctl
        sway-audio-idle-inhibit
        swaynotificationcenter
        blueman
        hyprpicker
        udiskie
        udisks
        libappindicator-gtk3
      ];
    };

    programs.hyprland = {
      # Install the packages from nixpkgs
      enable = true;
      # Whether to enable XWayland
      xwayland.enable = true;
    };

    home-manager.users.fred = {
      home.packages = with pkgs; [
        networkmanagerapplet
        adw-gtk3
      ];

      catppuccin.hyprland.enable = true;

      services.network-manager-applet.enable = true;
      # services.hypridle = {
      #   enable = true;

      #   settings = {
      #     general = {
      #       ignore_dbus_inhibit = false;
      #       ignore_systemd_inhibit = false;
      #     };
      #   };
      # };

      wayland.windowManager.hyprland = {
        enable = true;

        settings = {
          "$mainMod" = "SUPER";
          "$fileManager" = "yazi";
          "$terminal" = "wezterm";
          "$email" = "geary -n";

          env = [
            "QT_QPA_PLATFORMTHEME,qt6ct"
            "XCURSOR_SIZE, 24"
            # "GTK_THEME, adw-gtk3-dark"
          ];

          exec = [

          ];

          exec-once = [
            "polkit-agent-helper-1"
            # "gsettings set org.gnome.desktop.interface color-scheme \"prefer-dark\""
            # "gsettings set org.gnome.desktop.interface gtk-theme \"adw-gtk3-dark\""
            # "hyprctl setcursor Adwaita 24"
            "systemctl start --user polkit-gnome-authentication-agent-1"
            "systemctl start --user waybar"
            "systemctl start --user swaync"
            "systemctl start --user network-manager-applet"
            "~/.config/hyprextra/scripts/sleep"
            "sway-audio-idle-inhibit"
            "swaybg -o \"*\" -i \"/home/fred/.config/backgrounds/lewis.jpg\" &"
            "nm-applet --indicator"
            "1password --silent &"
            "udiskie --appindicator -t &"
            "geary --gapplication-service"
            "[workspace 1 silent] firefox"
            "[workspace 2 silent] code"
            "[workspace 2 silent] wezterm"
            "[workspace 3 silent] discord"
          ];

          exec-shutdown = [
            "systemctl stop --user waybar"
            "systemctl stop --user swaync"
            "systemctl stop --user network-manager-applet"
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
            "$mainMod, E, exec, $email"
            "$mainMod, T, exec, $terminal"
            "$mainMod SHIFT, T, exec, $terminal start -- bash"
            "$mainMod, A, exec, nautilus"
            "$mainMod, S, exec, code"
            "CTRL, SPACE, exec, fuzzel"
            "ALT, SPACE, exec, ulauncher"
            "$mainMod, C, killactive"
            "$mainMod, M, exit"
            "$mainMod, L, exec, ~/.config/hyprextra/scripts/pauseandsleep"

            # Move windows with mainMod + arrow keys
            "$mainMod, left, movewindow, l"
            "$mainMod, right, movewindow, r"
            "$mainMod, up, movewindow, u"
            "$mainMod, down, movewindow, d"

            # Move focus with mainMod + SHIFT + arrow keys
            "$mainMod SHIFT, left, movefocus, l"
            "$mainMod SHIFT, right, movefocus, r"
            "$mainMod SHIFT, up, movefocus, u"
            "$mainMod SHIFT, down, movefocus, d"

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
            "$mainMod, mouse_down, workspace, e-1"
            "$mainMod, mouse_up, workspace, e+1"
          ];

          binde = [
            ", XF86AudioRaiseVolume, exec, ~/.config/hyprextra/scripts/volume --inc "
            ", XF86AudioLowerVolume, exec, ~/.config/hyprextra/scripts/volume --dec "
            ", XF86AudioMute, exec, ~/.config/hyprextra/scripts/volume --toggle"
            ", XF86AudioMicMute, exec, ~/.config/hyprextra/scripts/volume --toggle-mic"
            ", XF86AudioPlay, exec, playerctl play-pause"
            ", XF86AudioPause, exec, playerctl play-pause"
            ", XF86AudioNext, exec, playerctl next"
            ", XF86AudioPrev, exec, playerctl previous"
            ", XKB_KEY_XF86KbdBrightnessUp, exec, ~/.config/hyprextra/scripts/kbbacklight --inc"
            ", XKB_KEY_XF86KbdBrightnessDown, exec, ~/.config/hyprextra/scripts/kbbacklight --dec"
            ", XF86SelectiveScreenshot, exec, grim -g \"$(slurp)\""
            ", XF86Display, exec, ~/.config/hyprextra/scripts/pauseandsleep"
            ", code:248, exec, $terminal"
            ", XF86Favorites, exec, fuzzel"
            "$mainMod, XF86MonBrightnessUp, exec, ~/.config/hyprextra/scripts/kbbacklight --inc"
            "$mainMod, XF86MonBrightnessDown, exec, ~/.config/hyprextra/scripts/kbbacklight --dec"
          ];

          bindm = [
            # Move/resize windows with mainMod + LMB/RMB and dragging
            "$mainMod, mouse:272, movewindow"
            "$mainMod, mouse:273, resizewindow"
          ];

          bindl = [
            # Lock lid on close
            ",switch:off:Lid Switch, exec, ~/.config/hyprextra/scripts/pauseandsleep"
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
