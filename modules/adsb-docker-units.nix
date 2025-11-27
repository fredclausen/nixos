{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.adsb;

  # Convert attrset → "-e KEY=value"
  mkEnvFlags = env: lib.concatStringsSep " " (lib.mapAttrsToList (k: v: ''-e "${k}=${v}"'') env);

  # Convert envFiles → "--env-file /path"
  mkEnvFileFlags = files: lib.concatStringsSep " " (map (f: ''--env-file "${f}"'') files);

  # Convert list of "/src:dst:mode" → "-v /src:dst:mode"
  mkVolumeFlags = vols: lib.concatStringsSep " " (map (v: ''-v "${v}"'') vols);

  # Convert tmpfs → "--tmpfs /path:options"
  mkTmpfsFlags = tmp: lib.concatStringsSep " " (map (t: ''--tmpfs "${t}"'') tmp);

  # Convert ports → "-p 80:80"
  mkPortFlags = ports: lib.concatStringsSep " " (map (p: ''-p "${p}"'') ports);

  mkServiceUnit =
    c:
    let
      envFlags = mkEnvFlags (c.environment or { });
      envFileFlags = mkEnvFileFlags (c.environmentFiles or [ ]);
      volumeFlags = mkVolumeFlags (c.volumes or [ ]);
      tmpfsFlags = mkTmpfsFlags (c.tmpfs or [ ]);
      portFlags = mkPortFlags (c.ports or [ ]);

      restartPolicy = c.restart or "always";
      execCmd = c.exec or "";
      ttyFlag = if (c.tty or false) then "--tty" else "";
    in
    ''
      [Unit]
      Description=Docker Container ${c.name}
      Wants=network-online.target
      After=network-online.target
      Requires=docker.service
      After=docker.service

      [Service]
      Restart=${restartPolicy}
      TimeoutStartSec=0

      ExecStartPre=-${pkgs.docker}/bin/docker rm -f ${c.name}
      ExecStartPre=${pkgs.docker}/bin/docker pull ${c.image}

      ExecStart=${pkgs.docker}/bin/docker run \
        --name ${c.name} \
        --privileged \
        ${ttyFlag} \
        ${envFlags} \
        ${envFileFlags} \
        ${volumeFlags} \
        ${tmpfsFlags} \
        ${portFlags} \
        ${c.extraDockerArgs or ""} \
        ${c.image} ${execCmd}

      ExecStop=${pkgs.docker}/bin/docker stop ${c.name}
      ExecStopPost=-${pkgs.docker}/bin/docker rm ${c.name}

      [Install]
      WantedBy=multi-user.target
    '';
in
{
  options.services.adsb.containers = lib.mkOption {
    type = lib.types.listOf lib.types.attrs;
    default = [ ];
    description = "List of ADS-B/ACARS/SDR containers to run under Docker with NixOS-backed systemd units.";
  };

  config = lib.mkIf (cfg.containers != [ ]) {

    virtualisation.docker.enable = true;

    systemd.services = lib.foldl' (
      acc: c:
      acc
      // {
        "${c.name}".serviceConfig = { };
        "${c.name}" = {
          enable = true;
          description = "Docker Container ${c.name}";
          serviceConfig = { };
          wantedBy = [ "multi-user.target" ];
          text = mkServiceUnit c;
        };
      }
    ) { } cfg.containers;
  };
}
