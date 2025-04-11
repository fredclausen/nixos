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
        bat
      ];

      programs.bat = {
        enable = true;
      };

      catppuccin.bat.enable = true;
    };
  };
}
