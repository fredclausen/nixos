{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.desktop.fonts;
in
{
  options.desktop.fonts = {
    enable = mkOption {
      description = "Install fonts.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.nerdfonts
      pkgs.fira-code
      pkgs.fira-code-symbols
    ];
  };
}
