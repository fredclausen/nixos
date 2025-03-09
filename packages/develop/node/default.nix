{ config, pkgs, ... }:
{
  config = {
    users.users.fred = {
      packages = with pkgs; [
        nodePackages_latest.nodejs
        nodePackages.prettier
        npm-check
      ];
    };
  };
}
