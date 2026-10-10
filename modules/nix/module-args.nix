{ config, lib, ... }:
let
  # A `key` makes importing the same feature from several parents include it only once.
  keyed =
    class:
    lib.mapAttrs (
      name: module: {
        key = "${class}.${name}";
        imports = [ module ];
      }
    );
in
{
  _module.args = lib.genAttrs [ "nixos" "homeManager" "generic" ] (
    class: keyed class (config.flake.modules.${class} or { })
  );
}
