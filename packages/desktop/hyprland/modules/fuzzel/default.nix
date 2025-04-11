{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.desktop.hyprland.modules.fuzzel;
in
{
  options.desktop.hyprland.modules.fuzzel = {
    enable = mkOption {
      description = "Enable fuzzel.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.fred = {
      programs.fuzzel = {
        enable = true;
        # settings = {
        #   colors = {
        #     background = "282a36dd";
        #     text = "f8f8f2ff";
        #     match = "8be9fdff";
        #     selection-match = "8be9fdff";
        #     selection = "44475add";
        #     selection-text = "f8f8f2ff";
        #     border = "bd93f9ff";
        #   };
        # };
      };
      catppuccin.fuzzel.enable = true;
    };
  };
}
