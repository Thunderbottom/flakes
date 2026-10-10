{ nixos, ... }:
{
  flake.modules.nixos.radarr =
    {
      config,
      lib,
      ...
    }:
    {
      imports = [ nixos.backup-registry ];

      config = {
        services.radarr.enable = true;
        services.radarr.group = "media";
        services.radarr.openFirewall = true;

        backups.radarr.paths = [
          config.services.radarr.dataDir
        ];
      };
    };
}
