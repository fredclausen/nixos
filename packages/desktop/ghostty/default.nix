{
  lib,
  pkgs,
  config,
  user,
  ...
}:

let
  username = user;
  cfg = config.desktop.ghostty;
  t = config.terminal;
in
{
  imports = [ ../../../modules/terminal/common.nix ];

  options.desktop.ghostty = {
    enable = lib.mkEnableOption "Enable Ghostty terminal emulator";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      home.packages = [ pkgs.ghostty ];

      programs.ghostty = {
        enable = true;

        settings = {
          font-family = t.font.family;
          font-size = t.font.size;
          background-opacity = t.opacity;
        };
      };

      catppuccin.ghostty.enable = true;

      xdg.mimeApps = {
        associations.added."x-terminal-emulator" = [ "ghostty.desktop" ];
        defaultApplications."x-terminal-emulator" = [ "ghostty.desktop" ];
      };
    };
  };
}
