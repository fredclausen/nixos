{
  lib,
  pkgs,
  config,
  inputs,
  imports,
  ...
}:
with lib;
let
  cfg = config.desktop.niri;
in
{
  options.desktop.niri = {
    enable = mkOption {
      description = "Install Niri.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    programs.niri = {
      enable = true;
    };
    programs.xwayland.enable = true;

    home-manager.users.fred = {
      programs.niri = {
        enable = true;
        settings = {
          hotkey-overlay.skip-at-startup = true;
          xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

          input = {
            mod-key = "Super";
          };

          spawn-at-startup = [
            { command = [ "polkit-agent-helper-1" ]; }

            {
              command = [
                "sh"
                "-c"
                "gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'"
              ];
            }

            {
              command = [
                "sh"
                "-c"
                "gsettings set org.gnome.desktop.interface gtk-theme 'Catppuccin-GTK-Purple-Dark'"
              ];
            }

            {
              command = [
                "systemctl"
                "--user"
                "start"
                "polkit-gnome-authentication-agent-1.service"
              ];
            }
            {
              command = [
                "systemctl"
                "--user"
                "start"
                "waybar.service"
              ];
            }
            {
              command = [
                "systemctl"
                "--user"
                "start"
                "swaync.service"
              ];
            }
            {
              command = [
                "systemctl"
                "--user"
                "start"
                "network-manager-applet.service"
              ];
            }

            { command = [ "/home/fred/.config/hyprextra/scripts/sleep" ]; }
            { command = [ "sway-audio-idle-inhibit" ]; }

            {
              command = [
                "${pkgs.swaybg}/bin/swaybg"
                "-o"
                "*"
                "-i"
                "/home/fred/.config/backgrounds/lewis.jpg"
              ];
            }

            {
              command = [
                "nm-applet"
                "--indicator"
              ];
            }
            {
              command = [
                "1password"
                "--silent"
              ];
            }
            {
              command = [
                "udiskie"
                "--appindicator"
                "-t"
              ];
            }
            {
              command = [
                "geary"
                "--gapplication-service"
              ];
            }
            {
              command = [
                "gnome-calendar"
                "--gapplication-service"
              ];
            }

            { command = [ "firefox" ]; }
            { command = [ "discord" ]; }
            { command = [ "wezterm" ]; }
          ];

          binds = {

            # --- App Launchers ---
            "Mod+F".action = {
              spawn = [ "firefox" ];
            };

            "Mod+E".action = {
              spawn = [
                "geary"
                "-n"
              ];
            };

            "Mod+T".action = {
              spawn = [ "wezterm" ];
            };

            "Mod+Shift+T".action = {
              spawn = [
                "wezterm"
                "start"
                "--"
                "bash"
              ];
            };

            "Mod+A".action = {
              spawn = [ "nautilus" ];
            };

            "Mod+S".action = {
              spawn = [ "code" ];
            };

            "Ctrl+Space".action = {
              spawn = [ "fuzzel" ];
            };

            "Alt+Space".action = {
              spawn = [ "ulauncher" ];
            };

            # --- Kill window / exit ---
            "Mod+C".action = {
              close-window = { };
            };

            "Mod+M".action = {
              quit = { };
            };

            # Lock / sleep
            "Mod+L".action = {
              spawn = [ "/home/fred/.config/hyprextra/scripts/pauseandsleep" ];
            };

            # --- Move windows (Hypr: movewindow) ---
            "Mod+Left".action = {
              move-column-left = { };
            };
            "Mod+Right".action = {
              move-column-right = { };
            };
            "Mod+Up".action = {
              move-window-to-workspace-up = { };
            };
            "Mod+Down".action = {
              move-window-to-workspace-down = { };
            };

            # --- Move focus (Hypr: movefocus) ---
            "Mod+Shift+Left".action = {
              focus-column-left = { };
            };
            "Mod+Shift+Right".action = {
              focus-column-right = { };
            };
            "Mod+Shift+Up".action = {
              focus-window-or-workspace-up = { };
            };
            "Mod+Shift+Down".action = {
              focus-window-or-workspace-down = { };
            };

            # --- Screenshots ---
            "Print".action = {
              spawn = [
                "sh"
                "grim"
              ];
            };
            "Mod+Print".action = {
              spawn = [
                "sh"
                "-c"
                "grim -g \"$(slurp)\""
              ];
            };

            # --- Workspace switching ---
            "Mod+1".action = {
              focus-workspace = 1;
            };
            "Mod+2".action = {
              focus-workspace = 2;
            };
            "Mod+3".action = {
              focus-workspace = 3;
            };
            "Mod+4".action = {
              focus-workspace = 4;
            };
            "Mod+5".action = {
              focus-workspace = 5;
            };
            "Mod+6".action = {
              focus-workspace = 6;
            };
            "Mod+7".action = {
              focus-workspace = 7;
            };
            "Mod+8".action = {
              focus-workspace = 8;
            };
            "Mod+9".action = {
              focus-workspace = 9;
            };
            "Mod+0".action = {
              focus-workspace = 10;
            };

            # --- Move active window to workspace ---
            "Mod+Shift+1".action = {
              move-column-to-workspace = 1;
            };
            "Mod+Shift+2".action = {
              move-column-to-workspace = 2;
            };
            "Mod+Shift+3".action = {
              move-column-to-workspace = 3;
            };
            "Mod+Shift+4".action = {
              move-column-to-workspace = 4;
            };
            "Mod+Shift+5".action = {
              move-column-to-workspace = 5;
            };
            "Mod+Shift+6".action = {
              move-column-to-workspace = 6;
            };
            "Mod+Shift+7".action = {
              move-column-to-workspace = 7;
            };
            "Mod+Shift+8".action = {
              move-column-to-workspace = 8;
            };
            "Mod+Shift+9".action = {
              move-column-to-workspace = 9;
            };
            "Mod+Shift+0".action = {
              move-column-to-workspace = 10;
            };

            # --- Workspace scroll (mouse wheel) ---
            "Mod+WheelScrollDown".action = {
              focus-workspace-down = { };
            };
            "Mod+WheelScrollUp".action = {
              focus-workspace-up = { };
            };

          };

        };
      };

      xdg = {
        mimeApps = {
          associations.added = {
            "text/html" = [ "firefox.desktop" ];
            "x-scheme-handler/http" = [ "firefox.desktop" ];
            "x-scheme-handler/https" = [ "firefox.desktop" ];
            "x-scheme-handler/about" = [ "firefox.desktop" ];
            "x-scheme-handler/unknown" = [ "firefox.desktop" ];
          };

          defaultApplications = {
            "text/html" = [ "firefox.desktop" ];
            "x-scheme-handler/http" = [ "firefox.desktop" ];
            "x-scheme-handler/https" = [ "firefox.desktop" ];
            "x-scheme-handler/about" = [ "firefox.desktop" ];
            "x-scheme-handler/unknown" = [ "firefox.desktop" ];
          };
        };
      };
    };
  };
}
