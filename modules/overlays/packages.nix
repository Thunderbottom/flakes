{
  flake.overlays.packages = _: prev: {
    nordwand-mono = prev.callPackage ../../packages/nordwand-mono { };
  };

  perSystem =
    { pkgs, ... }:
    {
      packages.nordwand-mono = pkgs.callPackage ../../packages/nordwand-mono { };
    };
}
