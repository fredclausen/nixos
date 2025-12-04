{
  pkgs,
  user,
  verbose_name,
  github_email,
  github_signing_key,
  ...
}:
let
  username = user;
  full_name = verbose_name;
  email = github_email;
in
{
  config = {
    environment.systemPackages = with pkgs; [
      git
      gh
      gnupg
      delta
    ];

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

        enable = true;

        signing = {
          signer = "${pkgs.gnupg}/bin/gpg";
          signByDefault = true;
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
