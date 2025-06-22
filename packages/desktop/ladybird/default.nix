{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.desktop.ladybird;
in
{
  options.desktop.ladybird = {
    enable = mkOption {
      description = "Install Ladybird browser.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    users.users.fred = {
      packages = with pkgs; [
        ladybird
      ];
    };
  };
}
