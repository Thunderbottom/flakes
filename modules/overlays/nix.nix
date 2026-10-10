{
  # One nix version everywhere, instead of the nixpkgs default plus the latest one.
  flake.overlays.nix = _: prev: { nix = prev.nixVersions.latest; };
}
