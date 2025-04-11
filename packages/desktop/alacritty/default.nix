{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.desktop.alacritty;
in
{
  options.desktop.alacritty = {
    enable = mkOption {
      description = "Enable Alacritty.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.fred = {
      home.packages = with pkgs; [
        alacritty
      ];

      programs.alacritty = {
        enable = true;
        settings = (builtins.fromTOML (builtins.readFile ../../../dotfiles/fred/.config/alacritty.toml));
      };

      catppuccin.alacritty.enable = true;
    };
  };
}
