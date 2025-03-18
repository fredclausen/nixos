{ pkgs, lib, ... }:
let
  username = "fred";
in
with lib.hm.gvariant;
{
  imports = [
    ./xdg.nix
    ./gnome.nix
    ./shell.nix
  ];

  # programs.git = {
  #   enable = true;
  #   userName = "Fred Clausen";
  #   userEmail = "fredclausen@users.noreply.github.com";
  #   signing = {
  #     gpgPath = "/run/current-system/sw/bin/gpg";
  #     signByDefault = true;
  #     key = "F406B080289FEC21";
  #   };
  #   lfs = {
  #     enable = true;
  #     skipSmudge = true;
  #   };
  # };

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    stateVersion = "24.11";

    packages = with pkgs; [
      zoxide
      oh-my-zsh
    ];
  };
}
