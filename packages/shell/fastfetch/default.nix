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
