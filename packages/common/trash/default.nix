{ config, pkgs, ... }:
{
  config = {
    environment.systemPackages = [
      pkgs.autotrash
      pkgs.gtrash
    ];

    home-manager.users.fred = {
      systemd.user.services = {
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

      systemd.user.timers = {
        autotrash = {
          Unit.Description = "Empty Trash";
          Timer = {
            Unit = "autotrash";
            OnCalendar = "06:00";
          };
          Install.WantedBy = [ "timers.target" ];
        };
      };
    };
  };
}
