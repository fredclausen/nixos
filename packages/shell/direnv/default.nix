{
  lib,
  pkgs,
  config,
  ...
}:
{
  config = {
    home-manager.users.fred = {
      home.packages = with pkgs; [
        direnv
      ];

      programs.direnv = {
        enable = true;
        enableZshIntegration = true;
        # Add any additional configuration for direnv here
      };
    };
  };
}
