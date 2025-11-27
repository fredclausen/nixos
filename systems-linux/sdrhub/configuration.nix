{
  config,
  pkgs,
  inputs,
  stateVersion,
  ...
}:
let
  dockerCompose = pkgs.writeText "docker-compose.yaml" (builtins.readFile ./docker-compose.yaml);
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  # Server profile (no desktop components)
  desktop.enable = false;
  desktop.enable_extra = false;
  desktop.enable_games = false;
  desktop.enable_streaming = false;

  networking.hostName = "sdrhub";

  environment.systemPackages = with pkgs; [ ];

  ###########################################
  # Unbound DNS Resolver
  ###########################################
  services.unbound = {
    enable = true;

    settings = {
      server = {
        interface = [ "127.0.0.1" ];
        port = 5335;
        access-control = [ "127.0.0.1 allow" ];

        harden-glue = true;
        harden-dnssec-stripped = true;
        use-caps-for-id = false;
        prefetch = true;
        edns-buffer-size = 1232;
        tls-system-cert = true;
        tls-use-sni = true;

        hide-identity = true;
        hide-version = true;
      };

      forward-zone = [
        {
          name = ".";
          forward-addr = [
            "9.9.9.11@853#dns11.quad9.net"
            "149.112.112.11@853#dns11.quad9.net"
          ];
          forward-tls-upstream = true;
          forward-first = false;
        }
      ];
    };
  };

  ###########################################
  # AdGuard Home (local upstream = Unbound)
  ###########################################
  services.adguardhome = {
    enable = true;
    openFirewall = true;

    settings = {
      http.address = "127.0.0.1:3003";

      dns = {
        upstream_dns = [ "127.0.0.1:5335" ];
        enable_dnssec = true;
        rate_limit = 0;

        edns_client_subnet = {
          enabled = true;
        };
      };

      filtering = {
        protection_enabled = true;
        filtering_enabled = true;
        parental_enabled = false;
        safe_search.enabled = false;
      };

      user_rules = [
        "@@||mask.icloud.com^"
        "@@||mask-h2.icloud.com^"
        "@@||mask-canary.icloud.com^"
        "@@||canary.mask.apple-dns.net^"
        "@@||s.youtube.com^"
        "@@||video-stats.l.google.com^"
        "@@||facebook.com^"
        "@@||fbcdn.net^"
        "@@||instagram.c10r.instagram.com^"
        "@@||instagram.com^"
        "@@||i.instagram.com^"
        "@@||cdninstagram.com^"
        "@@||fonts.gstatic.com^$important"
        "@@||analysis.chess.com^"
        "@@||stunnel.org^"
      ];

      filters =
        map
          (url: {
            enabled = true;
            url = url;
          })
          [
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt"
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt"
            "https://github.com/ppfeufer/adguard-filter-list/blob/master/blocklist?raw=true"
          ];
    };
  };

  ###########################################
  # Firewall
  ###########################################
  networking.firewall.allowedTCPPorts = [ 80 ];
  networking.firewall.allowedUDPPorts = [ 53 ];

  ###########################################
  # NGINX Reverse Proxy
  ###########################################
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;

    virtualHosts.localhost = {
      root = ./html;

      locations."/" = {
        index = "index.html";
      };

      locations."/dozzle/" = {
        proxyPass = "http://192.168.31.20:9999";
        extraConfig = ''proxy_redirect / /dozzle/;'';
      };

      locations."/tar1090/" = {
        proxyPass = "http://192.168.31.20:8080/";
        extraConfig = ''proxy_redirect / /tar1090/;'';
      };

      locations."/dump978/" = {
        proxyPass = "http://192.168.31.20:8083/";
        extraConfig = ''proxy_redirect / /dump978/;'';
      };

      locations."/graphs/" = {
        proxyPass = "http://192.168.31.20:8080/graphs1090/";
      };

      locations."/fr24/" = {
        return = "http://192.168.31.20:8082/";
      };

      locations."/fr24" = {
        return = "http://192.168.31.20:8082/";
      };

      locations."/piaware/" = {
        proxyPass = "http://192.168.31.20:8084/";
        extraConfig = ''proxy_redirect / /piaware/;'';
      };

      locations."/planefinder/" = {
        return = "http://192.168.31.20:8087";
      };

      locations."/planefinder" = {
        return = "http://192.168.31.20:8087";
      };

      locations."/acarshub/" = {
        proxyPass = "http://192.168.31.20:8085/";
        extraConfig = ''proxy_redirect / /acarshub/;'';
      };
    };
  };

  system.stateVersion = stateVersion;

  system.activationScripts.detect-reboot-required.text = ''
    readlink=${pkgs.coreutils}/bin/readlink
    touch=${pkgs.coreutils}/bin/touch
    rm=${pkgs.coreutils}/bin/rm

    booted="$($readlink /run/booted-system/kernel)"
    current="$($readlink /run/current-system/kernel)"

    if [ "$booted" != "$current" ]; then
      echo "Kernel changed; reboot required"
      $touch /run/reboot-required
    else
      $rm -f /run/reboot-required
    fi
  '';

  system.activationScripts.adsbDockerCompose = {
    text = ''
      # Ensure directory exists (does not touch contents if already there)
      install -d -m0755 -o fred -g users /opt/adsb

      # Always overwrite the compose file from the Nix store
      install -m0644 -o fred -g users ${dockerCompose} /opt/adsb/docker-compose.yaml
    '';
    deps = [ ];
  };

  sops.secrets = {
    "docker/sdrhub.env" = {
      path = "/opt/adsb/.env";
      owner = "fred";
    };
  };
}
