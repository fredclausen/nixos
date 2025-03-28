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
        theme = (builtins.fromTOML (builtins.readFile ../../../dotfiles/fred/.config/yazi/theme.toml));
      };
    };
  };
}
