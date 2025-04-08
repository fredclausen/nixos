{ config, pkgs, ... }:
{
  config = {
    users.users.fred = {
      packages = with pkgs; [
        ansible
      ];
    };

    home-manager.users.fred = {
      home.file.".ansible" = {
        source = ./plays;
        recursive = true;
      };
    };
  };
}
