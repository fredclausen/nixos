{
  lib,
  pkgs,
  config,
  ...
}:
{
  config = {
    home-manager.users.fred = {
      programs.lsd = {
        enable = true;
        enableAliases = true;
      };
    };
  };
}
