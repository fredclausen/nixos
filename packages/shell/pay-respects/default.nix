{
  lib,
  pkgs,
  config,
  ...
}:
{
  config = {
    home-manager.users.fred = {
      home.packages = with pkgs; [
        pay-respects
      ];

      programs.pay-respects = {
        enable = true;
      };
    };
  };
}
