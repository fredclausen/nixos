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
  cfg = config.desktop.stockfish;
in
{
  options.desktop.stockfish = {
    enable = mkOption {
      description = "Enable Sublime Text.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    users.users.${username} = {
      packages = with pkgs; [
        stockfish
        arena
      ];
    };
  };
}
