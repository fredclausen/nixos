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
    secrets."ssh/authorized_keys" = {
      path = "${homeDir}/.ssh/authorized_keys";
      owner = username;
      mode = "0600";
    };
  };

  users.users.${username}.openssh.authorizedKeys.keys = [
    config.sops.secrets."ssh/id_rsa.pub".path
    config.sops.secrets."ssh/id_ed25519.pub".path
  ];
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
