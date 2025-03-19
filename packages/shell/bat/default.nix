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
        config = {
          theme = "Monokai Extended";
          italic-text = "always";
        };
      };
    };
  };
}
