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
        eza
      ];

      programs.eza = {
        enable = true;
        colors = "always";
        enableZshIntegration = true;
        git = true;
        icons = "always";
      };
    };
  };
}
