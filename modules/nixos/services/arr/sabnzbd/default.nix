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

    # This needs to be changed as per the port specified in the configuration.
    networking.firewall.allowedTCPPorts = [8085];
  };
}
