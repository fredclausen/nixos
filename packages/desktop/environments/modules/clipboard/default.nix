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
  cfg = config.desktop.environments.modules.clipboard;
in
{
  options.desktop.environments.modules.clipboard = {
    enable = mkOption {
      description = "Enable clipboard stuff for hyprland.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    users.users.${username} = {
      packages = with pkgs; [
        cliphist
        wl-clipboard
      ];
    };

    home-manager.users.${username}.wayland.windowManager.hyprland = {
      settings = {
        exec-once = [
          "wl-paste --type text --watch cliphist store"
          "wl-paste --type image --watch cliphist store"
        ];

        bind = [
          "SUPER, V, exec, cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"
        ];
      };
    };
  };
}
