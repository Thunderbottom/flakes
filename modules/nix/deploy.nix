{
  config,
  inputs,
  lib,
  ...
}:
{
  flake = {
    deploy.nodes = lib.mapAttrs (hostName: _: {
      hostname = hostName;
      sshUser = "root";
      profiles.system.path =
        inputs.deploy-rs.lib.x86_64-linux.activate.nixos
          config.flake.nixosConfigurations.${hostName};
    }) config.configurations.nixos;

    checks.x86_64-linux = inputs.deploy-rs.lib.x86_64-linux.deployChecks config.flake.deploy;
  };
}
