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

      home.packages = [ pkgs.fastfetch ];

      programs.fastfetch = {
        enable = true;

        settings = builtins.fromJSON (builtins.readFile ./config.json);
      };
    };
  };
}
