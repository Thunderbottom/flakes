{ nixos, ... }:
{
  flake.modules.nixos.sonarr =
    {
      config,
      lib,
      ...
    }:
    {
      imports = [ nixos.backup-registry ];

      config = {
        services.sonarr.enable = true;
        services.sonarr.group = "media";
        services.sonarr.openFirewall = true;

        backups.sonarr.paths = [
          config.services.sonarr.dataDir
        ];
      };
    };
}
