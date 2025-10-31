{
  config,
  lib,
  ...
}:
{
  options.snowflake.services.prowlarr = {
    enable = lib.mkEnableOption "Enable prowlarr deployment configuration";
  };

  config = lib.mkIf config.snowflake.services.prowlarr.enable {
    services.prowlarr.enable = true;
    services.prowlarr.openFirewall = true;

    snowflake.services.backups.config.prowlarr.paths = [
      config.services.prowlarr.dataDir
    ];
  };
}
