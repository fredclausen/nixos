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
        lazygit
      ];

      programs.lazygit = {
        enable = true;
        settings = {
          gui = {
            nerdFontsVersion = "3";
          };
        };
      };

      catppuccin.lazygit.enable = true;
    };
  };
}
