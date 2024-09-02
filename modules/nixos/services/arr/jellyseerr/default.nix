{
  config,
  lib,
  ...
}: {
  options.snowflake.services.jellyseerr = {
    enable = lib.mkEnableOption "Enable jellyseerr deployment configuration";
  };

  config = lib.mkIf config.snowflake.services.jellyseerr.enable {
    services.jellyseerr.enable = true;
    services.jellyseerr.openFirewall = true;
    services.nginx = {
      virtualHosts = {
        "seerr.deku.moe" = {
          serverName = "seerr.deku.moe";
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://localhost:5055/";
          };
        };
      };
    };
  };
}
