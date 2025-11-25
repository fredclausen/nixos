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

      # Install bat
      home.packages = [ pkgs.bat ];

      programs.bat = {
        enable = true;

        config = {
          italic-text = "always";
          pager = "less --RAW-CONTROL-CHARS --quit-if-one-screen --mouse";
        };
      };

      # Theme
      catppuccin.bat.enable = true;
    };
  };
}
