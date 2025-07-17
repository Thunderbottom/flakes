{
  config,
  lib,
  ...
}:
{
  options.snowflake.services.technitium = {
    enable = lib.mkEnableOption "Enable technitium dns server";
  };

  config = lib.mkIf config.snowflake.services.technitium.enable {
    snowflake.meta.ports.list = config.services.technitium-dns-server.firewallTCPPorts;

    services.technitium-dns-server.enable = true;
    services.technitium-dns-server.openFirewall = true;
  };
}
