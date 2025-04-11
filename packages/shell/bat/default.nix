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

      home.file.".config/bat/" = {
        source = ../../../dotfiles/fred/.config/bat;
        recursive = true;
      };

      home.file.".config/bat/themes/Catppuccin-mocha.tmTheme" = {
        source = ../../../dotfiles/fred/.config/yazi/Catppuccin-mocha.tmTheme;
      };
      # themes = {
      #     Catppuccin-mocha= {
      #       src = builtins.readFile ../../../dotfiles/fred/.config/yazi/Catppuccin-mocha.tmTheme;
      #       file = "Catppuccin-mocha.tmTheme";
      #     };
      #   };

      #   config = {
      #     theme = "Catppuccin-Mocha";
      #     italic-text = "always";
      #   };
      # };
    };
  };
}
