{ self, ... }:
{
  systems = [ "x86_64-linux" ];

  perSystem =
    { lib, pkgs, ... }:
    {
      packages =
        "${self}/packages"
        |> builtins.readDir
        |> lib.filterAttrs (_: type: type == "directory")
        |> lib.mapAttrs (name: _: pkgs.callPackage "${self}/packages/${name}" { });
    };
}
