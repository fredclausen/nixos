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
        fzf
      ];

      programs.fzf = {
        enable = true;
        enableZshIntegration = true;
      };

      catppuccin.fzf.enable = true;
    };
  };
}
