{ inputs, ... }:
{
  flake.overlays.inputs = _: prev: {
    inherit (inputs.maych-in.packages.${prev.stdenv.hostPlatform.system}) maych-in;
    inherit (inputs.toasters.packages.${prev.stdenv.hostPlatform.system}) toaste-rs;
  };
}
