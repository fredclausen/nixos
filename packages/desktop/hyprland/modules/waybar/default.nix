{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.desktop.hyprland.modules.waybar;
in
{
  options.desktop.hyprland.modules.waybar = {
    enable = mkOption {
      description = "Enable waybar.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.fred = {
      home.packages = with pkgs; [
        wttrbar
      ];

      programs.waybar = {
        enable = true;

        settings = {
          "mainBar" = {
            "layer" = "top";
            "position" = "top";
            "height" = 24;
            "spacing" = 4;

            "modules-left" = [
              "temperature"
              "custom/weather"
              "tray"
            ];

            "modules-center" = [
              "hyprland/window"
            ];

            "modules-right" = [
              "network"
              "battery"
              "pulseaudio"
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
              "format-icons" = {
                "1" = "🦊";
                "2" = "🗨️";
                "3" = "📝";
                "4" = "🖥️";
                # "5" = "";
                # "6" = "";
              };
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
                "<span font='Font Awesome 5'></span>  <span font='Font Awesome 5 11'>{icon}</span>  {capacity}% - {time}";
              "format-full" =
                "<span font='Font Awesome 5'></span>  <span font='Font Awesome 5 11'>{icon}</span>  Charged";
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
                  "months" = "<span color='#ffead3'><b>{}</b></span>";
                  "days" = "<span color='#ecc6d9'><b>{}</b></span>";
                  "weeks" = "<span color='#99ffdd'><b>W{}</b></span>";
                  "weekdays" = "<span color='#ffcc66'><b>{}</b></span>";
                  "today" = "<span color='#ff6699'><b><u>{}</u></b></span>";
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
          @define-color rosewater #f5e0dc;
          @define-color flamingo #f2cdcd;
          @define-color pink #f5c2e7;
          @define-color mauve #cba6f7;
          @define-color red #f38ba8;
          @define-color maroon #eba0ac;
          @define-color peach #fab387;
          @define-color yellow #f9e2af;
          @define-color green #a6e3a1;
          @define-color teal #94e2d5;
          @define-color sky #89dceb;
          @define-color sapphire #74c7ec;
          @define-color blue #89b4fa;
          @define-color lavender #b4befe;
          @define-color text #cdd6f4;
          @define-color subtext1 #bac2de;
          @define-color subtext0 #a6adc8;
          @define-color overlay2 #9399b2;
          @define-color overlay1 #7f849c;
          @define-color overlay0 #6c7086;
          @define-color surface2 #585b70;
          @define-color surface1 #45475a;
          @define-color surface0 #313244;
          @define-color base #1e1e2e;
          @define-color mantle #181825;
          @define-color crust #11111b;


          * {
              font-family: "MesloLGS Nerd Font Mono Bold";
              font-size: 16px;
              min-height: 0;
              font-weight: bold;
          }

          window#waybar {
              background: transparent;
              background-color: @crust;
              color: @overlay0;
              transition-property: background-color;
              transition-duration: 0.1s;
              border-bottom: 1px solid @overlay1;
          }

          #window {
              margin: 8px;
              padding-left: 8;
              padding-right: 8;
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

          #workspaces button {
              padding: 0 4px;
          }

          #workspaces button.focused {
              background-color: rgba(0, 0, 0, 0.3);
              color: @rosewater;
              border-top: 2px solid @rosewater;
          }

          #workspaces button.active {
              background-color: rgba(0, 0, 0, 0.3);
              color: @mauve;
              border-top: 2px solid @mauve;
          }

          #workspaces button.urgent {
              background-color: #eb4d4b;
          }

          #pulseaudio,
          #clock,
          #battery,
          #cpu,
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
          #scratchpad {
            margin-top: 2px;
            margin-bottom: 2px;
            margin-left: 4px;
            margin-right: 4px;
            padding-left: 4px;
            padding-right: 4px;
          }

          #temperature {
              color: @sky;
              border-bottom: 2px solid @sky;
          }
          #custom-weather {
              color: @teal;
              border-bottom: 2px solid @teal;
          }

          #tray {
              color: @blue;
              border-bottom: 2px solid @blue;
          }

          #clock {
              color: @maroon;
              border-bottom: 2px solid @maroon;
          }

          #clock.date {
              color: @mauve;
              border-bottom: 2px solid @mauve;
          }

          #pulseaudio {
              color: @blue;
              border-bottom: 2px solid @blue;
          }

          #network {
              color: @yellow;
              border-bottom: 2px solid @yellow;
          }

          #custom-notification {
              color: @pink;
              border-bottom: 2px solid @pink;
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
              border-bottom: 2px solid @green;
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
              color: @lavender;
              border-radius: 15px;
              padding-left: 6px;
              padding-right: 6px;
          }

        '';
      };
    };
  };
}
