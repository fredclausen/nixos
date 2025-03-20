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
    };
  };
}
