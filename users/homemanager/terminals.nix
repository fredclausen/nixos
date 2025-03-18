{ pkgs, lib, ... }:
let
  username = "fred";
in
with lib.hm.gvariant;
{
  programs.ghostty = {
    enable = true;

    settings = {
      font-family = "MesloLGS Nerd Font Mono";
      font-size = 10;
      theme = "Wez";
    };
  };

  programs.wezterm = {
    enable = true;

    extraConfig = builtins.readFile ../../dotfiles/fred/.wezterm.lua;
  };
}
