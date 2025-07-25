{
  config,
  lib,
  ...
}:
{
  options.snowflake.services.radarr = {
    enable = lib.mkEnableOption "Enable radarr deployment configuration";
  };

  config = lib.mkIf config.snowflake.services.radarr.enable {
    services.radarr.enable = true;
    services.radarr.group = "media";
    services.radarr.openFirewall = true;
  };
}
