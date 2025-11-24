{
  lib,
  pkgs,
  config,
  user,
  ...
}:
let
  username = user;
in
{
  config = {
    home-manager.users.${username} = {
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
