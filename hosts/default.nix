{
  inputs,
  self,
  lib,
  ...
}:
let
  # agenix secrets
  # TODO: potentially move to per-system
  userdata = import "${self}/data.nix";
  # common modules across all systems
  mkHost = hostName: {
    ${hostName} = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit
          inputs
          self
          userdata
          ;
      };
      modules =
        let
          hostFiles =
            "${self}/hosts/${hostName}"
            |> lib.filesystem.listFilesRecursive
            |> builtins.filter (lib.hasSuffix ".nix");
        in
        [
          { networking = { inherit hostName; }; }
          "${self}/hosts/shared.nix"
        ]
        ++ hostFiles;
    };
  };

  mkDeployNode = hostName: {
    ${hostName} = {
      hostname = hostName;
      sshUser = "root";
      profiles.system.path =
        inputs.deploy-rs.lib.x86_64-linux.activate.nixos
          self.nixosConfigurations.${hostName};
    };
  };
in
{
  flake = {
    nixosConfigurations =
      "${self}/hosts"
      |> builtins.readDir
      |> lib.filterAttrs (_: type: type == "directory")
      |> lib.concatMapAttrs (name: _: mkHost name);

    deploy.nodes =
      "${self}/hosts"
      |> builtins.readDir
      |> lib.filterAttrs (_: type: type == "directory")
      |> lib.concatMapAttrs (name: _: mkDeployNode name);

    checks = builtins.mapAttrs (_: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;
  };
}
