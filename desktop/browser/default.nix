{ config, pkgs, ... }:
{
  config = {
    # Install firefox.
    programs.firefox.enable = true;
  };
}
