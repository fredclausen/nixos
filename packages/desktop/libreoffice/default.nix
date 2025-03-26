{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.desktop.libreoffice;
in
{
  options.desktop.libreoffice = {
    enable = mkOption {
      description = "Enable LibreOffice.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      libreoffice-qt
      hunspell
      hunspellDicts.en_US
    ];
  };
}
