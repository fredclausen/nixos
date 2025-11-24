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
        python3
      ];
    };
  };
}
