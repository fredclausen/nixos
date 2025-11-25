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
  cfg = config.desktop.alacritty;
  isDarwin = pkgs.stdenv.isDarwin;

  alacrittyConfig =
    if isDarwin then
      ../../../dotfiles/fred/.config/alacritty_darwin.toml
    else
      ../../../dotfiles/fred/.config/alacritty.toml;
in
{
  options.desktop.alacritty = {
    enable = mkOption {
      description = "Enable Alacritty.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        alacritty
      ];

      programs.alacritty = {
        enable = true;

        settings = builtins.fromTOML (builtins.readFile alacrittyConfig);
      };

      catppuccin.alacritty.enable = true;
    };
  };
}
