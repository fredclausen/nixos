{ config, pkgs, ... }:
{
  config = {
    users.users.fred = {
      packages = with pkgs; [
        hadolint
      ];
    };
  };
}
