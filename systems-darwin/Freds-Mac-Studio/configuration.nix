{
  pkgs,
  lib,
  inputs,
  user,
  config,
  hostName,
  ...
}:
let
  username = user;
in
{
  environment = {
    systemPackages = [ pkgs.coreutils ];
    systemPath = [ "/opt/homebrew/bin" ];
    pathsToLink = [ "/Applications" ];
    variables.EDITOR = "nvim";
  };

  system = {
    defaults = {
      dock = {
        dashboard-in-overlay = false;
        magnification = false;
        orientation = "bottom";
        show-recents = false;
        tilesize = 32;
        wvous-br-corner = 1;
        wvous-bl-corner = 1;
        wvous-tl-corner = 1;
        wvous-tr-corner = 1;
      };
    };
    primaryUser = "${username}";
    stateVersion = 6;
  };

  security.pam.services = {
    sudo_local = {
      touchIdAuth = true;
      reattach = true;
      watchIdAuth = true;
    };
  };

  networking.hostName = hostName;

  users.users.${username}.home = "/Users/${username}";

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-darwin";

  imports = [
    inputs.home-manager.darwinModules.default
    ../../modules/secrets/sops.nix
    # ../../modules/github-runners-darwin.nix
    ../../packages/shell
    ../../packages/common/btop
    ../../packages/common/git
    ../../packages/desktop/alacritty
    ../../packages/desktop/githubdesktop
    ../../packages/desktop/ghostty
    ../../packages/desktop/wezterm
    ../../packages/desktop/zed
    ../../packages/desktop/yubikey
  ];

  desktop = {
    wezterm.enable = true;
    alacritty.enable = true;
    zed.enable = true;
  };

  deployment.role = "desktop";

  sops_secrets.enable_secrets.enable = true;

  sops.secrets = {
    "github-token" = {
      owner = "fred";
      mode = "600";
    };
  };

  services.github-runners = {
    "studio-runner-1" = {
      enable = true;
      url = "https://github.com/fredsystems/nixos";
      tokenFile = config.sops.secrets."github-token".path;
      user = "fred";
    };
  };

  # ci.githubRunners = {
  #   enable = true;
  #   repo = "fredsystems/nixos";
  #   defaultTokenFile = config.sops.secrets."github-token".path;

  #   runners = {
  #     runner-1 = {
  #       url = "https://github.com/FredSystems/nixos";
  #       tokenFile = config.sops.secrets."github-token".path;
  #     };

  #     runner-2 = {
  #       url = "https://github.com/FredSystems/nixos";
  #       tokenFile = config.sops.secrets."github-token".path;
  #     };

  #     runner-3 = {
  #       url = "https://github.com/FredSystems/nixos";
  #       tokenFile = config.sops.secrets."github-token".path;
  #     };

  #     runner-4 = {
  #       url = "https://github.com/FredSystems/nixos";
  #       tokenFile = config.sops.secrets."github-token".path;
  #     };
  #   };
  # };

  home-manager.users.${username} =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        wget
        unzip
        file
        lsd
        zip
        toybox
        dig
        jq
        socat
        nmap
        delta
        dateutils
        gnuplot
        cargo-watch
        zeromq
        rrdtool
      ];

      programs.firefox.enable = true;
    };

  fonts = {
    packages = with pkgs; [
      cascadia-code
      nerd-fonts.caskaydia-mono
      nerd-fonts.caskaydia-cove
    ];
  };
}
