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
      programs.direnv = {
        enable = true;
        enableZshIntegration = true;
        enableFishIntegration = false;
        # Add any additional configuration for direnv here
      };
    };
  };
}
