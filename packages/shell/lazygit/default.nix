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
        lazygit
        gmp
      ];

      programs.lazygit = {
        enable = true;
        settings = {
          gui = {
            nerdFontsVersion = "3";
          };
        };
      };

      catppuccin.lazygit.enable = true;
    };
  };
}
