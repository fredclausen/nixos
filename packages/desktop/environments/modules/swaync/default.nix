{
  lib,
  config,
  user,
  pkgs,
  ...
}:
with lib;
let
  username = user;
  cfg = config.desktop.environments.modules.swaync;
in
{
  options.desktop.environments.modules.swaync = {
    enable = mkOption {
      description = "Enable swaync.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    # DO NOT enable the HM swaync service
    home-manager.users.${username} = {
      home.packages = [ pkgs.swaynotificationcenter ];

      xdg.configFile."swaync/config.json".source = ./config.json;
      # FIXME: This is hard coded to Catppuccin Mocha. I used to have this
      # set via catppuccin flake. However, in order to disable systemd for this
      # stupid thing (fuck how systemd works for this thing) I had to just hard code
      # the color scheme. It is tagged/pinned to v1.0.1 on github.
      # https://github.com/catppuccin/swaync/releases
      xdg.configFile."swaync/style.css".source = ./style.css;
    };
  };
}
