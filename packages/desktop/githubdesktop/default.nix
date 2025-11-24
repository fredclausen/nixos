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
    users.users.${username} = {
      packages = with pkgs; [
        github-desktop
      ];
    };
  };
}
