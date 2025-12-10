{
  user,
  ...
}:
let
  username = user;
in
{
  # ------------------------------
  # Host-specific Home Manager overrides for Freds-MacBook-Pro
  # ------------------------------

  imports = [
    ../../modules/sync-compose.nix
    ../../modules/ansible/ansible.nix
  ];

  programs.ansible.enable = true;

  services.yubikey-agent.enable = true;

  programs.sync-compose = {
    enable = true;
    user = username; # comes from flake.nix

    hosts = [
      # SDR Hub
      {
        name = "sdrhub";
        ip = "192.168.31.20";
        directory = "sdrhub";
        remotePath = "/opt/adsb";
        port = "22";
        legacyScp = false;
      }

      # HFDL Hub 1
      {
        name = "hfdlhub-1";
        ip = "192.168.31.19";
        directory = "hfdlhub-1";
        remotePath = "/opt/adsb";
        port = "22";
        legacyScp = false;
      }

      # HFDL Hub 2
      {
        name = "hfdlhub-2";
        ip = "192.168.31.17";
        directory = "hfdlhub-2";
        remotePath = "/opt/adsb";
        port = "22";
        legacyScp = false;
      }

      # ACARS Hub
      {
        name = "acarshub";
        ip = "192.168.31.24";
        directory = "acarshub";
        remotePath = "/opt/adsb";
        port = "22";
        legacyScp = false;
      }

      # VDL Hub
      {
        name = "vdlmhub";
        ip = "192.168.31.23";
        directory = "vdlmhub";
        remotePath = "/opt/adsb";
        port = "22";
        legacyScp = false;
      }

      # VPS (fredclausen.com)
      {
        name = "vps";
        ip = "fredclausen.com";
        directory = "vps";
        remotePath = "/home/${user}";
        port = "22";
        legacyScp = false;
      }

      # Brandon (special port + legacy scp)
      {
        name = "brandon";
        ip = "73.242.200.187";
        directory = "brandon";
        remotePath = "/opt/adsb";
        port = "3222";
        legacyScp = true;
      }
    ];
  };
}
