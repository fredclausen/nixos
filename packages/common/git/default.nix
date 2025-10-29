{ config, pkgs, ... }:
{
  config = {
    environment.systemPackages = [
      pkgs.git
      pkgs.gh
      pkgs.gnupg
    ];

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    home-manager.users.fred = {
      programs.diff-so-fancy = {
        enable = true;
        enableGitIntegration = true;
      };
      programs.git = {
        settings = {
          core = {
            email = "43556888+fredclausen@users.noreply.github.com";
            name = "Fred Clausen";
          };

          "credential \"https://github.com\"" = {
            helper = "!/etc/profiles/per-user/fred/bin/gh auth git-credential";
          };
          "credential \"https://gist.github.com\"" = {
            helper = "!/etc/profiles/per-user/fred/bin/gh auth git-credential";
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
