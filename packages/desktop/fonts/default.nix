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
    # environment.systemPackages = [
    #   pkgs.nerdfonts
    #   pkgs.fira-code
    #   pkgs.fira-code-symbols
    # ];

    fonts.packages = with pkgs; [
      nerdfonts
      fira-code
      fira-code-symbols
      font-awesome
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
    ];

    fonts.fontconfig.useEmbeddedBitmaps = true;
  };
}
