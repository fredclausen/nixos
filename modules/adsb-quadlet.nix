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
      ttyLine = if (c.tty or false) then "Terminal=true" else "";
      restartLine = if c ? restart then "Restart=${c.restart}" else "";
    in
    ''
      [Unit]
      Description=ADSB Container ${c.name}
      Wants=network-online.target
      After=network-online.target

      [Container]
      Image=${c.image}
      ${execLine}
      ${ttyLine}
      ${restartLine}
      ${envFileBlock}
      ${envBlock}
      ${volumeBlock}
      ${tmpfsBlock}
      ${deviceBlock}
      ${portBlock}

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
    environment.etc."containers/".directory = true;

    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      # you can drop dockerCompat later if you don't need Docker CLI compat
    };

    # This is the IMPORTANT bit: write Quadlet files where podman expects them.
    environment.etc =
      lib.foldl'
        (
          acc: c:
          acc
          // {
            "containers/systemd/${c.name}.container".source = pkgs.writeText "${c.name}.container" (
              mkContainerUnit c
            );
          }
        )
        {
          "containers/".directory = true;
          "containers/systemd/".directory = true;
        }
        cfg.containers;

  };
}
