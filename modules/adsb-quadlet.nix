{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.adsb;

  # Convert { key = value; } → multiple Environment=key=value lines
  mkEnv = env: lib.concatStringsSep "\n" (lib.mapAttrsToList (k: v: "Environment=${k}=${v}") env);

  # Convert [ "a", "b" ] → repeated lines like "Key=a\nKey=b"
  mkList = key: xs: lib.concatStringsSep "\n" (map (x: "${key}=${x}") xs);

  mkContainerUnit =
    c:
    let
      envBlock = mkEnv (c.environment or { });
      envFileBlock = mkList "EnvironmentFile" (c.environmentFiles or [ ]);
      volumeBlock = mkList "Volume" (c.volumes or [ ]);
      portBlock = mkList "PublishPort" (c.ports or [ ]);
      tmpfsBlock = mkList "Tmpfs" (c.tmpfs or [ ]);
      deviceBlock = mkList "Device" (c.devices or [ ]);

      execLine = if c ? exec then "Exec=${c.exec}" else "";
      serviceDeviceBlock = mkList "DeviceAllow" [
        "/dev/bus/usb rw"
        "char-usb rw"
      ];

      #ttyLine = if (c.tty or false) then "Interactive=true" else "";
      #restartLine = if c ? restart then "Restart=${c.restart}" else "";

      # ${ttyLine}
      # ${restartLine}
    in
    ''
      [Unit]
      Description=ADSB Container ${c.name}
      Wants=network-online.target
      After=network-online.target

      [Container]
      Image=${c.image}
      PodmanArgs=--privileged --device=/dev/bus/usb:/dev/bus/usb:rwm
      ${execLine}
      ${envFileBlock}
      ${envBlock}
      ${volumeBlock}
      ${tmpfsBlock}
      ${deviceBlock}
      ${portBlock}

      [Service]
      ${serviceDeviceBlock}

      [Install]
      WantedBy=multi-user.target
    '';
in
{
  options.services.adsb.containers = lib.mkOption {
    type = lib.types.listOf lib.types.attrs;
    default = [ ];
    description = "List of ADS-B/ACARS/SDR containers to run via Podman Quadlet.";
  };

  config = lib.mkIf (cfg.containers != [ ]) {
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      # you can drop dockerCompat later if you don't need Docker CLI compat
    };

    # environment.etc."containers/containers.conf".source = lib.mkForce (
    #   pkgs.writeText "containers.conf" ''
    #     # Quadlet fix: make this file real so the systemd podman generator works.
    #     [containers]
    #     default_runtime="crun"
    #   ''
    # );

    environment.etc = lib.foldl' (
      acc: c:
      acc
      // {
        "containers/systemd/${c.name}.container".text = mkContainerUnit c;
      }
    ) { } cfg.containers;

    # system.activationScripts.adsbQuadlet.text =
    #   let
    #     files = lib.concatStringsSep "\n" (
    #       map (c: ''
    #                     echo "Writing ${c.name}.container"
    #                     install -m 0644 /dev/stdin /etc/containers/systemd/${c.name}.container <<'EOF'
    #         ${mkContainerUnit c}
    #         EOF
    #       '') cfg.containers
    #     );
    #   in
    #   ''
    #     mkdir -p /etc/containers/systemd
    #     ${files}
    #   '';

  };
}
