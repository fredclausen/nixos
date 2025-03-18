{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.desktop.sqlitebrowser;
in
{
  options.desktop.sqlitebrowser = {
    enable = mkOption {
      description = "Enable SQLite Browser.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    users.users.fred = {
      packages = with pkgs; [
        sqlitebrowser
      ];
    };
  };
}
