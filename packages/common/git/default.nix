{
  pkgs,
  user,
  verbose_name,
  github_email,
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
            helper = "!/etc/profiles/per-user/${username}/bin/gh auth git-credential";
          };
          "credential \"https://gist.github.com\"" = {
            helper = "!/etc/profiles/per-user/${username}/bin/gh auth git-credential";
          };
        };

        enable = true;

        signing = {
          signer = "${pkgs.gnupg}/bin/gpg";
          signByDefault = true;
          key = "F406B080289FEC21";
        };

        lfs = {
          enable = true;
          skipSmudge = false;
        };
      };
    };
  };
}
