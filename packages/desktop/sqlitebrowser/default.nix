{
  lib,
  pkgs,
  config,
  user,
  ...
}:
with lib;
let
  username = user;
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
    users.users.${username} = {
      packages = with pkgs; [
        sqlitebrowser
      ];
    };
  };
}
