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

  config = mkIf cfg.enable {
    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the GNOME Desktop Environment.
    services.xserver.displayManager.gdm.enable = true;

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

      wayland.windowManager.hyprland = {
        enable = true;

        settings = {
          "$mainMod" = "SUPER";
          "$fileManager" = "yazi";
          "$terminal" = "ghostty";

          general = {
            "gaps_in" = 2;
            "gaps_out" = 2;
            "border_size" = 2;
            "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
            "col.inactive_border" = "rgba(595959aa)";
          };

          decoration = {
            "rounding" = 10;
            blur = {
              enabled = true;
              size = 3;
              passes = 1;
            };

            # drop_shadow = "yes";
            # shadow_range = 4;
            # shadow_render_power = 3;
            # "col.shadow" = "rgba(1a1a1aee)";
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

          binds = {
            scroll_event_delay = 0;
          };

          #windowrulev2 = "nomaximizerequest, class:.*";

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
