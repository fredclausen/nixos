{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.adsb;

  # Convert { key = value; } to multiple Environment=key=value lines
  mkEnv = env: lib.concatStringsSep "\n" (lib.mapAttrsToList (k: v: "Environment=${k}=${v}") env);

  # Convert [ "/path:/path:ro" ... ] into repeated lines like Key=/path...
  mkList = key: xs: lib.concatLines (map (x: "${key}=${x}") xs);

  mkContainerUnit =
    c:
    let
      envBlock = mkEnv (c.environment or { });
      volumeBlock = mkList "Volume" (c.volumes or [ ]);
      portBlock = mkList "PublishPort" (c.ports or [ ]);
      tmpfsBlock = mkList "Tmpfs" (c.tmpfs or [ ]);
      deviceBlock = mkList "Device" (c.devices or [ ]);

      execLine = if (c ? exec) then "Exec=${c.exec}" else "";
      ttyLine = if (c.tty or false) then "Terminal=true" else "";
      restartLine = if (c ? restart) then "Restart=${c.restart}" else "";
    in
    ''
      [Unit]
      Description=Container ${c.name}
      Wants=network-online.target
      After=network-online.target

      [Container]
      Image=${c.image}
      ${execLine}
      ${ttyLine}
      ${restartLine}
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
    description = ''
      List of ADS-B/ACARS/SDR containers to run on this host via Quadlet.
      Each entry is an attribute set describing one container.
    '';
  };

  config = lib.mkIf (cfg.containers != [ ]) {
    virtualisation.podman = {
      enable = true;
      dockerCompat = true; # optional, gives you /run/docker.sock
    };

    # Generate 1 .container unit per entry
    environment.etc = lib.foldl' (
      acc: c:
      acc
      // {
        "containers/systemd/${c.name}.container".text = mkContainerUnit c;
      }
    ) { } cfg.containers;
  };
}
