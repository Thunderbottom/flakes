{ self, lib, ... }:
let
  modulesOf = dir: dir |> lib.filesystem.listFilesRecursive |> builtins.filter (lib.hasSuffix ".nix");
in
{
  flake = {
    nixosModules.default.imports = modulesOf "${self}/modules/nixos";
    homeModules.default.imports = modulesOf "${self}/modules/home";
  };
}
