{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
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
    users.users.fred = {
      packages = with pkgs; [
        stockfish
        arena
      ];
    };
  };
}
