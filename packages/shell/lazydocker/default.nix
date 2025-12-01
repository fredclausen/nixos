{ user, ... }:
let
  username = user;
in
{
  config = {
    home-manager.users.${username} =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          lazydocker
        ];

        programs.lazydocker = {
          enable = true;
          settings = {
            gui = {
              nerdFontsVersion = "3";
            };
          };
        };
      };
  };
}
