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
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        pay-respects
      ];

      # programs.pay-respects = {
      #   enable = true;
      # };
    };
  };
}
