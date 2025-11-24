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
        bat
      ];

      programs.bat = {
        enable = true;
      };

      catppuccin.bat.enable = true;
    };
  };
}
