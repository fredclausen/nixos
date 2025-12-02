{
  pkgs,
  user,
  ...
}:
let
  username = user;
in
{
  # local github runner test
  config = {
    users.users.${username} = {
      packages = with pkgs; [
        act
      ];
    };
  };
}
