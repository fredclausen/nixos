{
  lib,
  pkgs,
  config,
  user,
  ...
}:
let
  username = user;
  cfg = config.desktop.alacritty;

  isDarwin = pkgs.stdenv.isDarwin;

  fontName = if isDarwin then "CaskaydiaCove Nerd Font" else "Caskaydia Cove Nerd Font";
in
{
  options.desktop.alacritty = {
    enable = lib.mkEnableOption "Enable Alacritty terminal emulator";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      home.packages = [ pkgs.alacritty ];

      programs.alacritty = {
        enable = true;

        # Full TOML config is generated here via Nix → TOML
        settings = {
          env.TERM = "xterm-256color";

          window = {
            padding = {
              x = 10;
              y = 10;
            };
            decorations = "Buttonless";
            opacity = 1.0;
            blur = true;

            # macOS only field; harmless on Linux but let's be clean
            option_as_alt = lib.mkIf isDarwin "Both";
          };

          font = {
            normal.family = fontName;
            size = 12;
          };
        };
      };

      catppuccin.alacritty.enable = true;
    };
  };
}
