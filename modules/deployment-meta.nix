{ lib, ... }:

{
  options.deployment = lib.mkOption {
    type = lib.types.attrsOf lib.types.anything;
    default = { };
    description = "Metadata describing deployment roles and grouping.";
  };
}
