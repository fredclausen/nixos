{
  lib,
  pkgs,
  config,
  ...
}:
{
  config = {
    home-manager.users.fred = {
      programs.lsd = {
        enable = true;
        enableZshIntegration = true;
      };

      catppuccin.lsd.enable = true;
    };
  };
}
