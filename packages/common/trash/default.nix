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
    environment.systemPackages = [
      pkgs.autotrash
      pkgs.gtrash
    ];

    home-manager.users.${username} = {
      systemd.user = {
        services = {
          autotrash = {
            Unit = {
              Description = "Empty Trash";
            };
            Service = {
              Type = "oneshot";
              ExecStart = "${pkgs.autotrash}/bin/autotrash --days 10";
            };
          };
        };

        timers = {
          autotrash = {
            Unit.Description = "Empty Trash";
            Timer = {
              Unit = "autotrash.service";
              Persistent = true;
              OnCalendar = "06:00";
            };
            Install.WantedBy = [ "timers.target" ];
          };
        };
      };
    };
  };
}
