{
  lib,
  pkgs,
  config,
  ...
}:
{
  config = {
    home-manager.users.fred = {
      home.packages = with pkgs; [
        starship
      ];

      programs.starship = {
        enable = true;
        settings = (builtins.fromTOML (builtins.readFile ../../../dotfiles/fred/.config/starship.toml));
      };

      catppuccin.starship.enable = true;
    };
  };
}
