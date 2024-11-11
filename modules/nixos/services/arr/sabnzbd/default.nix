{
  config,
  lib,
  ...
}: {
  options.snowflake.services.sabnzbd = {
    enable = lib.mkEnableOption "Enable sabnzbd deployment configuration";
  };

  config = lib.mkIf config.snowflake.services.sabnzbd.enable {
    services.sabnzbd.enable = true;
    services.sabnzbd.group = "media";
    services.sabnzbd.openFirewall = true;
  };
}
