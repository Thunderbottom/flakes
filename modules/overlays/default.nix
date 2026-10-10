{ config, lib, ... }:
{
  # Composes every overlay defined in this directory.
  flake.overlays.default = lib.composeManyExtensions (
    lib.attrValues (lib.removeAttrs config.flake.overlays [ "default" ])
  );
}
