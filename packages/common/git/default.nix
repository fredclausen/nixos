{
  pkgs,
  user,
  verbose_name,
  github_email,
  github_signing_key,
  system,
  lib,
  ...
}:
let
  username = user;
  full_name = verbose_name;
  email = github_email;
  isDarwin = lib.hasSuffix "darwin" system;
  isLinux = !isDarwin;
  homeDir = if isDarwin then "/Users/${username}" else "/home/${username}";
in
{
  config = {
    environment.systemPackages =
      with pkgs;
      [
        git
        gh
        gnupg
        delta
      ]
      ++ lib.optional isLinux pinentry-tty
      ++ lib.optional isDarwin pinentry_mac;

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    home-manager.users.${username} = {
      programs.diff-so-fancy = {
        enable = true;
        enableGitIntegration = true;
      };

      programs.git = {
        settings = {
          core = {
            email = "${email}";
            name = "${full_name}";
          };

          "credential \"https://github.com\"" = {
            helper = "!${pkgs.gh}/bin/gh auth git-credential";
          };
          "credential \"https://gist.github.com\"" = {
            helper = "!${pkgs.gh}/bin/gh auth git-credential";
          };
        };

        extraConfig = {
          gpg.format = "ssh";

          gpg.ssh.allowedSignersFile = "${homeDir}/.config/git/allowed_signers";
        };

        enable = true;

        signing = {
          signer = "${pkgs.gnupg}/bin/gpg";
          signByDefault = false;
          key = github_signing_key;
        };

        lfs = {
          enable = true;
          skipSmudge = false;
        };
      };
    };
  };
}
