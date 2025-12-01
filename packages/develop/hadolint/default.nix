{
  lib,
  pkgs,
  user,
  ...
}:

let
  username = user;

  ignoredRules = [
    "DL3003"
    "DL3006"
    "DL3010"
    "DL4001"
    "DL3007"
    "DL3008"
    "DL3013"
  ];

in
{
  config = {
    home-manager.users.${username} = {
      home.packages = [ pkgs.hadolint ];

      # Generate ~/.config/hadolint.yaml declaratively
      home.file.".config/hadolint.yaml".text = ''
        ignored:
      ''
      + lib.concatMapStrings (r: "  - ${r}\n") ignoredRules;
    };
  };
}
