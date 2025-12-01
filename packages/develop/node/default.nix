{
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
        nodePackages_latest.nodejs
        nodePackages.prettier
        npm-check
      ];
    };
  };
}
