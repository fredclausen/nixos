{
  config,
  pkgs,
  inputs,
  user,
  hmlib,
  ...
}:

{
  imports = [
    inputs.catppuccin.nixosModules.catppuccin
    ../../packages
    ../../users
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # catppuccin defaults (hosts can override)
  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "lavender";
  };
}
