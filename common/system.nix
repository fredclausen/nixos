{ config, pkgs, ... }:
{
  config = {
    environment.systemPackages = [
      pkgs.pass
      pkgs.wget
      pkgs.git
      pkgs.bash
      pkgs.zsh
    ];
  };
}
