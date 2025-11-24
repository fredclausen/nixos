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
        fastfetch
      ];

      programs.fastfetch = {
        enable = true;
        settings = (
          builtins.fromJSON (builtins.readFile ../../../dotfiles/fred/.config/fastfetch/config.jsonc)
        );
      };
    };
  };
}
