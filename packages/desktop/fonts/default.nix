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

    nixpkgs.config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "joypixels"
      ];
    nixpkgs.config.joypixels.acceptLicense = true;

    fonts.packages = with pkgs; [
      nerd-fonts.meslo-lg
      cascadia-code
      nerd-fonts.caskaydia-mono
      nerd-fonts.caskaydia-cove
      fira-code
      fira-code-symbols
      font-awesome
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      noto-fonts-extra
      twemoji-color-font
      noto-fonts-color-emoji
      google-fonts
      # corefonts
      # cifs-utils
      # dina-font
      # liberation_ttf
      # mplus-outline-fonts.githubRelease
      # powerline-fonts
      # proggyfonts
      # ubuntu_font_family
      # unifont
      # unifont_upper
      joypixels
      font-manager
    ];

    fonts.enableDefaultPackages = true;
    fonts.fontconfig.useEmbeddedBitmaps = true;
  };
}
