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
        zoxide
      ];

      programs.zoxide = {
        enable = true;
        enableZshIntegration = true;
        options = [
          "--cmd cd"
        ];
      };
    };
  };
}
