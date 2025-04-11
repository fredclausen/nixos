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
        fzf
      ];

      programs.fzf = {
        enable = true;
        enableZshIntegration = true;
      };

      catppuccin.fzf.enable = true;
    };
  };
}
