{
  lib,
  pkgs,
  config,
  user,
  ...
}:
with lib;
let
  username = user;
  cfg = config.desktop.environments.modules.waybar;
in
{
  options.desktop.environments.modules.waybar = {
    enable = mkOption {
      description = "Enable waybar.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        wttrbar
      ];

      catppuccin.waybar.enable = true;
      catppuccin.waybar.mode = "prependImport";

      programs.waybar = {
        enable = true;
        systemd = {
          enable = false;
        };

        settings = {
          "mainBar" = {
            "layer" = "top";
            "position" = "top";
            "height" = 34;
            "spacing" = 1;

            "modules-left" = [
              "hyprland/workspaces"
              "temperature"
              "custom/cpu"
              "custom/weather"
              "custom/vpn"
              "custom/updates"
              "tray"
            ];

            "modules-center" = [
              "hyprland/window"
            ];

            "modules-right" = [
              "custom/caffeine"
              "network"
              "battery"
              "pulseaudio"
              "custom/media"
              "clock"
              "custom/notification"
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
            };

            "custom/vpn" = {
              "exec" = "~/.config/hyprextra/scripts/waybar-vpn.sh";
              "return-type" = "json";
              "interval" = 5;
            };

            "custom/media" = {
              "exec" = "~/.config/hyprextra/scripts/waybar-media.sh";
              "return-type" = "json";
              "interval" = 2;
            };

            "custom/updates" = {
              "exec" = "~/.config/hyprextra/scripts/waybar-updates.sh";
              "return-type" = "json";
              "interval" = 600;
              "signal" = 8;
            };

            "custom/caffeine" = {
              "exec" = "~/.config/hyprextra/scripts/idleinhibit-toolbar.sh";
              "return-type" = "json";
              "interval" = 2;
              "tooltip" = true;
              "on-click" = "~/.config/hyprextra/scripts/idleinhibit.sh";
            };

            "hyprland/window" = {
              "max-length" = 128;
            };

            battery = {
              "format" = "<span font='Font Awesome 5 Free 11'>{icon}</span>  {capacity}% - {time}";
              "format-icons" = [
                ""
                ""
                ""
                ""
                ""
              ];
              "format-time" = "{H}h{M}m";
              "format-charging" =
                "<span font='Font Awesome 5 11'></span>  <span font='Font Awesome 5 11'>{icon}</span>  {capacity}% - {time}";
              "format-full" = "<span font='Font Awesome 5 11'></span>  Charged";
              "interval" = 30;
              "states" = {
                "warning" = 25;
                "critical" = 10;
              };
              "tooltip" = false;
              "on-click" = "2";
            };
            "clock" = {
              "format" = "{:%H:%M}  ";
              "format-alt" = "{:%A, %B %d, %Y (%R)} 📅︎ ";
              "tooltip-format" = "<tt><small>{calendar}</small></tt>";
              "calendar" = {
                "mode" = "year";
                "mode-mon-col" = 3;
                "weeks-pos" = "right";
                "on-scroll" = 1;
                "on-click-right" = "mode";
                "format" = {
                  "months" = "<span color='#fab387'><b>{}</b></span>";
                  "days" = "<span color='#cdd6f4'><b>{}</b></span>";
                  "weeks" = "<span color='#f5c2e7'><b>W{}</b></span>";
                  "weekdays" = "<span color='#f9e2af'><b>{}</b></span>";
                  "today" = "<span color='#f38ba8'><b>{}</b></span>";
                };
              };
              "actions" = {
                "on-click-right" = "mode";
                "on-click-forward" = "tz_up";
                "on-click-backward" = "tz_down";
                "on-scroll-up" = "shift_up";
                "on-scroll-down" = "shift_down";
              };
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

            "custom/cpu" = {
              "exec" = "~/.config/hyprextra/scripts/waybar-cpu-tooltip.sh";
              "return-type" = "json";
              "interval" = 2;
              "tooltip-format-markup" = true;
            };

            "temperature" = {
              "format" = "{icon} {temperatureC}°C";
              "format-critical" = "{icon} {temperatureC}°C";
              "hwmon-path" = "/sys/class/hwmon/hwmon2/temp1_input";
              "warning-threshold" = 70;
              "critical-threshold" = 85;
              "format-icons" = [
                ""
                ""
                ""
                "⚠️"
                "❗"
              ];
              "tooltip" = false;
            };

            "custom/separator" = {
              "format" = "|";
              "interval" = "once";
              "tooltip" = false;
            };

            "tray" = {
              "spacing" = 4;
            };

            "custom/notification" = {
              tooltip = false;
              format = "{} {icon}";
              "format-icons" = {
                notification = "󱅫";
                none = "";
                "dnd-notification" = " ";
                "dnd-none" = "󰂛";
                "inhibited-notification" = " ";
                "inhibited-none" = "";
                "dnd-inhibited-notification" = " ";
                "dnd-inhibited-none" = " ";
              };
              "return-type" = "json";
              "exec-if" = "which swaync-client";
              exec = "swaync-client -swb";
              "on-click" = "sleep 0.1 && swaync-client -t -sw";
              "on-click-right" = "sleep 0.1 && swaync-client -d -sw";
              escape = true;
            };

            "custom/weather" = {
              "format" = "{}°";
              "tooltip" = true;
              "interval" = 3600;
              "exec" = "wttrbar --mph --location Albuquerque --date-format %d-%m-%Y";
              "return-type" = "json";
            };

            "network" = {
              "format-wifi" = "<span size='13000' foreground='#f5e0dc'>  </span>{essid}";
              "format-ethernet" = "<span size='13000' foreground='#f5e0dc'>󰤭  </span> Disconnected";
              "format-linked" = "{ifname} (No IP) ";
              "format-disconnected" = "<span size='13000' foreground='#f5e0dc'>  </span>Disconnected";
              "tooltip-format-wifi" = "Signal Strength: {signalStrength}%";
            };
          };
        };

        style = ''
          * {
              font-family: "SFProDisplay Nerd Font";
              font-size: 14px;
              min-height: 0;
              font-weight: bold;
          }

          tooltip {
            background: @base;
            border-radius: 10px;
            border: 2px solid @yellow;
            padding: 8px;
          }

          window#waybar {
              background-color: rgba(30, 30, 46, 0.70); /* catppuccin-mocha base with transparency */
              color: @overlay0;
              transition-property: background-color;
              transition-duration: 0.1s;
              border-bottom: 1px solid @overlay1;
          }

          #window {
              margin-top: 2px;
              margin-bottom: 0px;
              margin-left: 4px;
              margin-right: 4px;
              padding-left: 4px;
              padding-right: 4px;
              background-color: @base;
              border-radius: 10px;
              color: @mauve;
              border: 2px solid @mauve;
          }

          button {
              box-shadow: inset 0 -3px transparent;
              border: none;
              border-radius: 0;
          }

          button:hover {
              background: inherit;
              color: @mauve;
              border-top: 2px solid @mauve;
          }

          #workspaces {
              margin: 2px;
              padding: 0px 2px;   /* horizontal only */

              background-color: @base;
              border-radius: 14px;
              border: 2px solid @overlay1;
          }

          #workspaces button {
              margin: 1px 2px;
              padding: 1px 3px;

              background: transparent;

              border-radius: 10px;
              border: 2px solid transparent;

              min-height: 0;

              color: @overlay0;

              transition: all 0.15s ease-in-out;
          }

          #workspaces button:hover {
              background-color: rgba(0, 0, 0, 0.25);
              color: @base;
              background: @rosewater;
              border-color: @mauve;
          }

          #workspaces button.active:hover {
              background-color: rgba(0, 0, 0, 0.25);
              color: @base;
              background: @rosewater;
              border-color: @mauve;
          }

          #workspaces button.focused:hover {
              background-color: rgba(0, 0, 0, 0.25);
              color: @base;
              background: @rosewater;
              border-color: @mauve;
          }

          #workspaces button.focused {
              background-color: rgba(0, 0, 0, 0.3);
              color: @rosewater;
              border-top: 2px solid @rosewater;
          }

          #workspaces button.active {
              background-color: rgba(0, 0, 0, 0.3);
              color: @mauve;
              border: 2px solid @mauve;
          }

          #workspaces button.urgent {
              background-color: #eb4d4b;
          }

          #pulseaudio,
          #clock,
          #battery,
          #cpu,
          #custom-cpu,
          #memory,
          #disk,
          #temperature,
          #backlight,
          #wireplumber,
          #tray,
          #network,
          #mode,
          #custom-notification,
          #custom-weather,
          #custom-caffeine,
          #custom-media,
          #custom-vpn,
          #custom-updates,
          #scratchpad {
            margin-left: 2px;
            margin-right: 2px;
            margin-top: 0px;
            margin-bottom: 0px;
            padding: 2px 8px;
            background-color: @base;
            border-radius: 10px;
          }

          #cpu {
              color: @lavender;
              border: 2px solid @lavender;
          }

          #custom-cpu {
              color: @lavender;
              border: 2px solid @lavender;
          }

          #temperature {
              color: @peach;
              border: 2px solid @peach;
          }
          #custom-weather {
              color: @blue;
              border: 2px solid @blue;
          }

          #tray {
              color: @maroon;
              border: 2px solid @maroon;
          }

          #clock {
              color: @maroon;
              border: 2px solid @maroon;
          }

          #clock.date {
              color: @mauve;
              border: 2px solid @mauve;
          }

          #pulseaudio {
              color: @blue;
              border: 2px solid @blue;
          }

          #network {
              color: @yellow;
              border: 2px solid @yellow;
          }

          #custom-notification {
              color: @pink;
              border: 2px solid @pink;
          }

          #custom-caffeine {
              color: @pink;
              border: 2px solid @sapphire;
              font-family: "SFProDisplay Nerd Font, Font Awesome 7 Free";
              font-weight: 900;
          }

          /* Active (coffee) */
          #custom-caffeine.active {
            color: @flamingo;
          }

          /* Inactive (sleep) */
          #custom-caffeine.inactive {
            color: @sapphire;
          }

          /* External (busy) */
          #custom-caffeine.external {
            color: @mauve;
          }

          #idle_inhibitor {
              margin-right: 12px;
              color: #7cb342;
          }

          #idle_inhibitor.activated {
              color: @red;
          }

          #battery {
              color: @green;
              border: 2px solid @green;
          }

          /* If workspaces is the leftmost module, omit left margin */
          .modules-left>widget:first-child>#workspaces {
              margin-left: 0;
          }

          /* If workspaces is the rightmost module, omit right margin */
          .modules-right>widget:last-child>#workspaces {
              margin-right: 0;
          }

          #custom-vpn {
            border: 2px solid @lavender;
            color: @lavender;
          }

          #custom-vpn.active {
            color: @green;
            border-color: @green;
          }

          #custom-vpn.inactive {
            color: @overlay1;
            border-color: @overlay1;
          }

          #custom-media {
            border: 2px solid @sky;
            color: @sky;
          }

          #custom-media.mic {
            color: @red;
            border-color: @red;
          }

          #custom-media.audio {
            color: @blue;
            border-color: @blue;
          }

          #custom-media.idle {
            color: @overlay1;
            border-color: @overlay1;
          }

          #custom-updates {
            border: 2px solid @green;
            color: @green;
          }

          #custom-updates.clean {
            border: 2px solid @green;
            color: @green;
          }

          #custom-updates.updates {
            color: @yellow;
            border-color: @yellow;
          }

          #custom-updates.reboot {
            color: @red;
            border-color: @red;
          }
        '';
      };
    };
  };
}
