{
  config,
  pkgs,
  inputs,
  lib,
  system,
  user,
  ...
}:
let
  username = user;
  isDarwin = lib.hasSuffix "darwin" system;
  isLinux = !isDarwin;

  homeDir = if isDarwin then "/Users/${username}" else "/home/${username}";
in
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  environment.systemPackages = [
    pkgs.sops
  ];

  sops = {
    defaultSopsFile = ./secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "${homeDir}/.config/sops/age/keys.txt";

    secrets."ssh/id_ed25519" = {
      path = "${homeDir}/.ssh/id_ed25519";
      owner = username;
      mode = "0600";
    };
    secrets."ssh/id_ed25519.pub" = {
      path = "${homeDir}/.ssh/id_ed25519.pub";
      owner = username;
    };
    secrets."ssh/id_rsa.pub" = {
      path = "${homeDir}/.ssh/id_rsa.pub";
      owner = username;
    };
    secrets."ssh/id_rsa" = {
      path = "${homeDir}/.ssh/id_rsa";
      owner = username;
      mode = "0600";
    };
  };

  users.users.${username}.openssh.authorizedKeys.keys = [
    config.sops.secrets."ssh/id_rsa.pub".path
    config.sops.secrets."ssh/id_ed25519.pub".path
  ];
}
