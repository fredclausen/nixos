# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
    ../../packages
    ../../users
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # extra options
  desktop.enable = false;
  desktop.enable_extra = false;
  desktop.enable_games = false;
  desktop.enable_streaming = false;

  catppuccin = {
    flavor = "mocha";
    accent = "lavender";
    enable = true;
  };

  networking.hostName = "sdrhub"; # Define your hostname.

  environment.systemPackages = with pkgs; [
  ];

  services.unbound = {
    enable = true;
    settings = {
      server = {
        # When only using Unbound as DNS, make sure to replace 127.0.0.1 with your ip address
        # When using Unbound in combination with pi-hole or Adguard, leave 127.0.0.1, and point Adguard to 127.0.0.1:PORT
        interface = [ "127.0.0.1" ];
        port = 5335;
        access-control = [ "127.0.0.1 allow" ];
        # Based on recommended settings in https://docs.pi-hole.net/guides/dns/unbound/#configure-unbound
        harden-glue = true;
        harden-dnssec-stripped = true;
        use-caps-for-id = false;
        prefetch = true;
        edns-buffer-size = 1232;

        # Custom settings
        hide-identity = true;
        hide-version = true;
      };
      forward-zone = [
        # Example config with quad9
        {
          name = ".";
          forward-addr = [
            "9.9.9.11@853#dns11.quad9.net"
            "149.112.112.11@853#dns11.quad9.net"
          ];
          forward-tls-upstream = true; # Protected DNS
          forward-first = false;
        }
      ];
    };
  };

  services.adguardhome = {
    enable = true;
    settings = {
      http = {
        # You can select any ip and port, just make sure to open firewalls where needed
        address = "127.0.0.1:3003";
      };
      dns = {
        upstream_dns = [
          "127.0.0.1:5335"
        ];
      };
      filtering = {
        protection_enabled = true;
        filtering_enabled = true;

        parental_enabled = false; # Parental control-based DNS requests filtering.
        safe_search = {
          enabled = false; # Enforcing "Safe search" option for search engines, when possible.
        };
      };
      # The following notation uses map
      # to not have to manually create {enabled = true; url = "";} for every filter
      # This is, however, fully optional
      filters =
        map
          (url: {
            enabled = true;
            url = url;
          })
          [
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt" # The Big List of Hacked Malware Web Sites
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt" # malicious url blocklist
          ];
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
  ];

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    virtualHosts.localhost = {
      locations."/" = {
        return =
          "200 '<!DOCTYPE html>
<html>

<head>
    <title>Fred's ADSB Hub</title>
    <style>
        body {
            width: 35em;
            margin: 0 auto;
            font-family: Tahoma, Verdana, Arial, sans-serif;
        }
    </style>
</head>

<body>
    <h1>Welcome to Fred's ADSB Hub!</h1>
    <ul>
        <li><a href="
            "http://192.168.31.20/tar1090"
            ">Tar1090</a></li>
        <li><a href="
            "http://192.168.31.20/dump978"
            ">dump978</a></li>
        <li><a href="
            "http://192.168.31.20/graphs"
            ">Tar1090 Graphs</a></li>
        <li><a href="
            "http://192.168.31.20/fr24"
            ">Flight Radar 24</a></li>
        <li><a href="
            "http://192.168.31.20/piaware"
            ">PiAware</a></li>
        <li><a href="
            "http://192.168.31.20/planefinder"
            ">Plane Finder</a></li>
        <li><a href="
            "http://192.168.31.20/acarshub"
            ">ACARS Hub</a></li>
        <li><a href="
            "http://192.168.31.20/dozzle"
            ">Dozzle</a></li>
        <li><a href="
            "http://192.168.31.20/influxdb"
            ">InfluxDB</a></li>
        <li><a href="
            "http://192.168.31.20/grafana"
            ">Grafana</a></li>
        <li><a href="
            "http://192.168.31.20/prometheus"
            ">Prometheus</a></li>
        <li><a href="
            "http://192.168.31.20/rackstation"
            ">Rackstation</a></li>
        <li><a href="
            "http://192.168.31.20/fam"
            ">FAM</a></li>
        <li><a href="
            "http://192.168.31.20/pihole"
            ">PiHole</a></li>
        <li><a href="
            "http://fredclausen.com/tar1090"
            ">Fred Clausen's Combined Tar1090</a></li>
        <li><a href="
            "http://acarshub.app"
            ">acarshub.app</a></li>
    </ul>
</body>

</html>'";
        extraConfig = ''
          default_type text/html;
        '';
      };

      locations."/dozzle" = {
        proxyPass = "http://192.168.31.20:9999/dozzle";
      };
    };
  };

  system.stateVersion = "24.11"; # Did you read the comment?
}
