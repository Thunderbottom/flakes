{
  self,
  lib,
  inputs,
  ...
}:
let
  # Get all overlay files from subdirectories in overlays directory
  customOverlays =
    "${self}/overlays"
    |> builtins.readDir
    |> lib.filterAttrs (_: type: type == "directory")
    |> builtins.attrNames
    |> builtins.concatMap (
      name:
      lib.filesystem.listFilesRecursive "${self}/overlays/${name}"
      |> builtins.filter (lib.hasSuffix ".nix")
    );

  # Input-based overlays for external packages
  inputOverlays = [
    (_: prev: {
      inherit (inputs.maych-in.packages.${prev.system}) maych-in;
      inherit (inputs.toasters.packages.${prev.system}) toaste-rs;
    })
  ];

in
{
  flake = {
    overlays = {
      default = lib.composeManyExtensions ((map import customOverlays) ++ inputOverlays);
    };
  };
}
