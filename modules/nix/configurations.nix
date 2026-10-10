{
  config,
  inputs,
  lib,
  ...
}:
{
  options.configurations.nixos = lib.mkOption {
    type = lib.types.lazyAttrsOf (
      lib.types.submodule {
        options.module = lib.mkOption {
          type = lib.types.deferredModule;
          default = { };
        };
      }
    );
    default = { };
  };

  config.flake.nixosConfigurations = lib.mapAttrs (
    hostName: cfg:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        inherit (inputs) self;
      };
      modules = [
        {
          networking = { inherit hostName; };
          nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
        }
        cfg.module
      ];
    }
  ) config.configurations.nixos;
}
