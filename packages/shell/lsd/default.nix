{
  user,
  ...
}:
let
  username = user;
in
{
  config = {
    home-manager.users.${username} = {
      programs.lsd = {
        enable = true;
        enableZshIntegration = true;
      };

      catppuccin.lsd.enable = true;
    };
  };
}
