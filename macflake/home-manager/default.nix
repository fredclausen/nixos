{ pkgs, config, ... }:
let
in
{
  imports = [
    #inputs.home-manager.darwinModules.default
  ];

  home = {
    stateVersion = "25.05";

    packages = with pkgs; [
    ];
  };
}
