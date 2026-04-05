{
  config,
  lib,
  ...
}:
let
  cfg = config.snowflake.services.cross-seed;
in
{
  options.snowflake.services.cross-seed = {
    enable = lib.mkEnableOption "Enable cross-seed for automatic cross-seeding";

    port = lib.mkOption {
      type = lib.types.port;
      default = 2468;
      description = "Port the cross-seed daemon listens on";
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "cross-seed settings (non-secret). See https://cross-seed.org/docs/config/options";
    };

    settingsFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to a JSON file with cross-seed secrets (e.g. torznab URLs with Prowlarr API key)";
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        services.cross-seed = {
          enable = true;
          group = "media";
          settings = { port = cfg.port; } // cfg.settings;
        };

        snowflake.meta.ports.list = [ cfg.port ];

        snowflake.services.backups.config.cross-seed.paths = [
          config.services.cross-seed.configDir
        ];
      }

      (lib.mkIf (cfg.settingsFile != null) {
        services.cross-seed.settingsFile = cfg.settingsFile;
      })
    ]
  );
}
