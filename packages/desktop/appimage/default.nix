{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.desktop.appimage;
in
{
  options.desktop.appimage = {
    # Updated to match the new configuration
    enable = mkOption {
      description = "Enable AppImage";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    users.users.fred = {
      packages = with pkgs; [
        appimage-run
      ];
    };

    boot.binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };
  };
}
