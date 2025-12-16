{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.desktop.environments;
in
{
  options.desktop.environments = {
    enable = mkOption {
      description = "Enable the desktop environments.";
      default = false;
    };
  };

  imports = [
    ./hyprland
    ./niri
    ./cosmic
    ./gnome
    ./modules
  ];

  config = mkIf cfg.enable {
    systemd = {
      user.services = {
        polkit-gnome-authentication-agent-1 = {
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

        one-password-agent = {
          description = "1Password Background";
          wantedBy = [ "graphical-session.target" ];
          wants = [
            "graphical-session.target"
            "waybar.service"
            "polkit-gnome-authentication-agent-1.service"
          ];
          after = [
            "graphical-session.target"
            "polkit-gnome-authentication-agent-1.service"
            "waybar.service"
          ];
          serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs._1password-gui}/bin/1password --silent";
            Restart = "on-failure";
            RestartSec = 1;
            TimeoutStopSec = 10;
          };
        };

        udiskie-agent = {
          description = "udiskie Background";
          wantedBy = [ "graphical-session.target" ];
          wants = [
            "graphical-session.target"
            "polkit-gnome-authentication-agent-1.service"
            "waybar.service"
          ];
          after = [
            "graphical-session.target"
            "polkit-gnome-authentication-agent-1.service"
            "waybar.service"
          ];
          serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.udiskie}/bin/udiskie --appindicator -t";
            Restart = "on-failure";
            RestartSec = 1;
            TimeoutStopSec = 10;
          };
        };

        sway-audio-idle-inhibit = {
          description = "sway-audio-idle-inhibit Background";
          wantedBy = [ "graphical-session.target" ];
          wants = [
            "graphical-session.target"
            "polkit-gnome-authentication-agent-1.service"
            "waybar.service"
          ];
          after = [
            "graphical-session.target"
            "polkit-gnome-authentication-agent-1.service"
            "waybar.service"
          ];
          serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.sway-audio-idle-inhibit}/bin/sway-audio-idle-inhibit";
            Restart = "on-failure";
            RestartSec = 1;
            TimeoutStopSec = 10;
          };
        };

        sway-background = {
          description = "sway-background Background";
          wantedBy = [ "graphical-session.target" ];
          wants = [
            "graphical-session.target"
            "polkit-gnome-authentication-agent-1.service"
            "waybar.service"
          ];
          after = [
            "graphical-session.target"
            "polkit-gnome-authentication-agent-1.service"
            "waybar.service"
          ];
          serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.swaybg}/bin/swaybg -o \"*\" -i \"%h/.config/backgrounds/lewis.jpg\"";
            Restart = "on-failure";
            RestartSec = 1;
            TimeoutStopSec = 10;
          };
        };
      };
    };

    desktop.environments = {
      hyprland.enable = true;
      niri.enable = true;
      cosmic.enable = true;
      gnome.enable = true;
    };
  };
}
