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
        yazi
      ];

      programs.yazi = {
        enable = true;
        theme = (builtins.fromTOML (builtins.readFile ../../../dotfiles/fred/.config/yazi/theme.toml));
      };
    };
  };
}
