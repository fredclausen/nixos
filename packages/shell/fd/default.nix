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
        fd
      ];

      programs.fd = {
        enable = true;
      };
    };
  };
}
