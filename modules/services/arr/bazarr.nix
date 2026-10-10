{ nixos, ... }:
{
  flake.modules.nixos.bazarr =
    {
      config,
      lib,
      ...
    }:
    {
      imports = [ nixos.backup-registry ];

      # NOTE: No good subtitle providers are available right now.
      # There's no need to enable bazarr, private trackers have decent
      # subtitles for releases.
      config = {
        services.bazarr.enable = true;
        services.bazarr.group = "media";
        services.bazarr.openFirewall = true;

        backups.bazarr.paths = [
          config.services.bazarr.dataDir
        ];
      };
    };
}
