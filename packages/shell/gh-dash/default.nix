{
  pkgs,
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
        gh-dash
      ];

      programs.gh-dash = {
        enable = true;
      };

      catppuccin.gh-dash.enable = true;
    };
  };
}
