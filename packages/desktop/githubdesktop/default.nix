{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.desktop.githubdesktop;
in
{
  options.desktop.githubdesktop = {
    enable = mkOption {
      description = "Enable GitHub Desktop.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    users.users.fred = {
      packages = with pkgs; [
        github-desktop
      ];
    };
  };
}
