{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.programs.ansible;
  username = config.home.username;
  isDarwin = lib.hasSuffix "darwin" pkgs.stdenv.hostPlatform.system;
  userHome = if isDarwin then "/Users/${username}" else "/home/${username}";

  # Import your host definitions
  hosts = import ./ansible-hosts.nix;

  # Boolean → string for YAML
  mkBool = v: if v then "true" else "false";

  ###########################################################
  # generate one host entry (returns a YAML block)
  ###########################################################
  genHostVars = name: host: ''
    ${host.ip}:
      ${lib.optionalString (host.port or null != null) "ansible_port: ${toString host.port}"}
      vars:
        docker_config: ${userHome}/GitHub/adsb-compose/${host.dir}/docker-compose.yaml
        docker_env:    ${userHome}/GitHub/adsb-compose/${host.dir}/.env
        docker_data:   ${userHome}/GitHub/adsb-compose/${host.dir}/data
        docker_path:   ${host.docker_path}
        slow_start:    ${mkBool host.slow_start}
        nix_name:      ${name}
  '';

  # group Ubuntu hosts
  ubuntuHosts = lib.concatStringsSep "\n" (
    lib.mapAttrsToList genHostVars (lib.filterAttrs (_: h: h.os == "ubuntu") hosts)
  );

  # group NixOS hosts
  nixosHosts = lib.concatStringsSep "\n" (
    lib.mapAttrsToList genHostVars (lib.filterAttrs (_: h: h.os == "nixos") hosts)
  );

  ###########################################################
  # indent lines inside generated blocks
  ###########################################################
  indent =
    n: str:
    let
      pad = lib.concatStrings (lib.replicate n " ");
    in
    lib.concatMapStrings (line: pad + line + "\n") (lib.splitString "\n" str);

  dropWhile =
    pred: xs:
    if xs == [ ] then
      [ ]
    else if pred (builtins.head xs) then
      dropWhile pred (builtins.tail xs)
    else
      xs;

  ###########################################################
  # remove leading/trailing blank lines after nixfmt edits
  ###########################################################
  clean =
    str:
    let
      lines = lib.splitString "\n" str;

      dropWhile =
        pred: xs:
        if xs == [ ] then
          [ ]
        else if pred (builtins.head xs) then
          dropWhile pred (builtins.tail xs)
        else
          xs;

      # remove leading
      noLeading = dropWhile (l: l == "") lines;

      # remove trailing: reverse → drop → reverse
      noTrailing =
        let
          rev = lib.reverseList noLeading;
        in
        lib.reverseList (dropWhile (l: l == "") rev);
    in
    lib.concatStringsSep "\n" noTrailing + "\n";

in
{
  ###########################################################
  # module option
  ###########################################################
  options.programs.ansible = {
    enable = lib.mkEnableOption "Generate Ansible inventory + playbooks automatically";
  };

  ###########################################################
  # actual configuration
  ###########################################################
  config = lib.mkIf cfg.enable {

    home.file.".ansible/inventory.yaml".text = clean ''
      ---
      ubuntu:
        hosts:
      ${indent 4 ubuntuHosts}
      nixos:
        hosts:
      ${indent 4 nixosHosts}

      adsb:
        children:
          ubuntu:
          nixos:

      all:
        vars:
          ansible_user: ${username}
          ansible_ssh_private_key_file: ~/.ssh/id_rsa
          ansible_connection: ssh
    '';

    home.file.".ansible/ansible.cfg".text = clean ''
      [defaults]
      inventory = ~/.ansible/inventory.yaml
      host_key_checking = False
      retry_files_enabled = False
      stdout_callback = default
      result_format = yaml
      interpreter_python = python3
    '';

    # copy your plays directory exactly
    home.file.".ansible/plays" = {
      source = ./plays;
      recursive = true;
    };
  };
}
