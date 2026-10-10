{ nixos, ... }:
{
  flake.modules.nixos.cross-seed =
    { config, lib, ... }:
    let
      cfg = config.profile.services.cross-seed;
      # Optional JSON secrets (e.g. torznab URLs) in `secrets/services/cross-seed/settings.age`.
      secret = config.profile.secrets.services.cross-seed.settings or null;
    in
    {
      imports = [ nixos.backup-registry ];

      config = lib.mkMerge [
        {
          services.cross-seed = {
            enable = true;
            group = "media";
            settings = {
              inherit (cfg) port;
            };
          };

          backups.cross-seed.paths = [
            config.services.cross-seed.configDir
          ];
        }

        (lib.mkIf (secret != null) {
          age.secrets.cross-seed.file = secret.file;
          services.cross-seed.settingsFile = config.age.secrets.cross-seed.path;
        })
      ];
    };
}
