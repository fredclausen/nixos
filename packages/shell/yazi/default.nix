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
      home.packages = with pkgs; [
        yazi

        # plugins for yazi
        ffmpeg
        p7zip
        jq
        poppler
        fd
        ripgrep
        fzf
        zoxide
        imagemagick
      ];

      programs.yazi = {
        enable = true;
        # theme = (builtins.fromTOML (builtins.readFile ../../../dotfiles/fred/.config/yazi/theme.toml));
      };

      catppuccin.yazi.enable = true;

      # home.file.".config/yazi/Catppuccin-mocha.tmTheme" = {
      #   source = ../../../dotfiles/fred/.config/yazi/Catppuccin-mocha.tmTheme;
      # };
    };
  };
}
