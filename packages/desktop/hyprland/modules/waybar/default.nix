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
              "custom/separator"
              "wlr/taskbar"
            ];

            "modules-center" = [
              "hyprland/window"
            ];

            "modules-right" = [
              "tray"
              "custom/separator"
              "battery"
              "custom/audio_idle_inhibitor"
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

            "custom/separator" = {
              "format" = "|";
              "interval" = "once";
              "tooltip" = false;
            };

            "tray" = {
              "spacing" = 4;
            };

            "custom/audio_idle_inhibitor" = {
              "format" = "{icon}";
              "exec" = "sway-audio-idle-inhibit --dry-print-both-waybar";
              "exec-if" = "which sway-audio-idle-inhibit";
              "return-type" = "json";
              "format-icons" = {
                "output" = "▶️";
                "input" = "🎤";
                "output-input" = "▶️  🎤";
                "none" = "✅";
              };
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
              background: @background-darker;
              color: @foreground;
          }
          #custom-separator {
            color: @pink;
            margin: 0 3px;
          }
        '';
      };
    };
  };
}
