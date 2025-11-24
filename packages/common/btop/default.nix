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
    environment.systemPackages = [
      pkgs.btop
    ];

    home-manager.users.${username} = {
      programs.btop = {
        enable = true;
      };
      catppuccin.btop.enable = true;
    };
  };
}
