{
  config,
  pkgs,
  user,
  ...
}:
let
  username = user;
in
{
  config = {
    users.users.${username} = {
      packages = with pkgs; [
        ansible
      ];
    };

    home-manager.users.${username} = {
      home.file.".ansible" = {
        source = ./plays;
        recursive = true;
      };
    };
  };
}
