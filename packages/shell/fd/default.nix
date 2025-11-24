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
        fd
      ];

      programs.fd = {
        enable = true;
      };
    };
  };
}
