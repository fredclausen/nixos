{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.desktop.firefox;
in
{
  options.desktop.firefox = {
    enable = mkOption {
      description = "Install Firefox browser.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    # Install firefox.
    programs.firefox.enable = true;
  };
}
