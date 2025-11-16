{
  lib,
  pkgs,
  config,
  ...
}:
{
  config = {
    home-manager.users.fred = {
      programs.direnv = {
        enable = true;
        enableZshIntegration = true;
        enableFishIntegration = false;
        # Add any additional configuration for direnv here
      };
    };
  };
}
