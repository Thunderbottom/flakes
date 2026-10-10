{ inputs, ... }:
{
  imports = [
    inputs.flake-parts.flakeModules.modules
    inputs.treefmt-nix.flakeModule
  ];

  systems = [ "x86_64-linux" ];
}
