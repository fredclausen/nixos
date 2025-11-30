{
  config,
  pkgs,
  inputs,
  lib,
  system,
  user,
  ...
}:
with lib;
let
  cfg = config.sops_secrets.enable_secrets;
  username = user;
  isDarwin = lib.hasSuffix "darwin" system;
  isLinux = !isDarwin;

  homeDir = if isDarwin then "/Users/${username}" else "/home/${username}";
in
{
  options.sops_secrets.enable_secrets = {
    enable = mkOption {
      description = "Enable SOPS Secrets.";
      default = false;
    };
  };

  imports = [
  ]
  ++ lib.optional isLinux inputs.sops-nix.nixosModules.sops
  ++ lib.optional isDarwin inputs.sops-nix.darwinModules.sops;

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.sops
    ];

    sops = {
      defaultSopsFile = ./secrets.yaml;
      defaultSopsFormat = "yaml";
      age.keyFile = "${homeDir}/.config/sops/age/keys.txt";

      # SSH
      secrets = {
        "ssh/id_ed25519" = {
          path = "${homeDir}/.ssh/id_ed25519";
          owner = username;
          mode = "0600";
        };
        "ssh/id_ed25519.pub" = {
          path = "${homeDir}/.ssh/id_ed25519.pub";
          owner = username;
        };
        "ssh/id_rsa.pub" = {
          path = "${homeDir}/.ssh/id_rsa.pub";
          owner = username;
        };
        "ssh/id_rsa" = {
          path = "${homeDir}/.ssh/id_rsa";
          owner = username;
          mode = "0600";
        };
        "ssh/authorized_keys" = {
          path = "${homeDir}/.ssh/authorized_keys";
          owner = username;
          mode = "0600";
        };
      };
    };

    users.users.${username}.openssh.authorizedKeys.keys = [
      config.sops.secrets."ssh/id_rsa.pub".path
      config.sops.secrets."ssh/id_ed25519.pub".path
    ];
  };
}

## This is the flow for adding a new system:
# 1. Clone this repository to the new system.
# 2. Run `add_new_system_sop.sh` to generate new age keys and SSH keys ON THE NEW SYSTEM. This is safe for a new system.
# 3. Add the new age public key to `.sops.yaml`. This needs to be done on a system that already has access to the secrets.
# 4. Re-encrypt the secrets with the updated keys `sops updatekeys secrets.yaml`
# 5. Commit the updated `.sops.yaml` and `secrets.yaml` files.
# 6. Push the changes to the repository.
# 7. On the new system, pull the latest changes from the repository.
# 8. Rebuild the NixOS configuration to apply the changes and decrypt the secrets.
