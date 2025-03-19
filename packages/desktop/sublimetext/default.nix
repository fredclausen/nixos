{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.desktop.sublimetext;
in
{
  options.desktop.sublimetext = {
    enable = mkOption {
      description = "Enable Sublime Text.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    users.users.fred = {
      packages = with pkgs; [
        sublime4
      ];
    };

    home-manager.users.fred.xdg = {
      mimeApps = {
        associations.added = {
          "text/plain" = [ "sublime_text.desktop" ];
          "application/x-zerosize" = [ "sublime_text.desktop" ];
        };

        defaultApplications = {
          "text/plain" = [ "sublime_text.desktop" ];
          "application/x-zerosize" = [ "sublime_text.desktop" ];
        };
      };
    };
  };
}
