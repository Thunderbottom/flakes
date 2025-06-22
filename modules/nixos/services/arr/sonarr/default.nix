{
  config,
  lib,
  ...
}:
{
  options.snowflake.services.sonarr = {
    enable = lib.mkEnableOption "Enable sonarr deployment configuration";
  };

  config = lib.mkIf config.snowflake.services.sonarr.enable {
    services.sonarr.enable = true;
    services.sonarr.group = "media";
    services.sonarr.openFirewall = true;
  };
}
