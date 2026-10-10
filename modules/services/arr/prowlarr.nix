{ nixos, ... }:
{
  flake.modules.nixos.prowlarr =
    {
      config,
      lib,
      ...
    }:
    {
      imports = [ nixos.backup-registry ];

      config = {
        services.prowlarr.enable = true;
        services.prowlarr.openFirewall = true;

        backups.prowlarr.paths = [
          config.services.prowlarr.dataDir
        ];
      };
    };
}
