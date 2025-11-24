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
        pre-commit
        # packages needed for my usual pre-commit plugins to work
        cabal-install
        ghc
      ];
    };
  };
}
