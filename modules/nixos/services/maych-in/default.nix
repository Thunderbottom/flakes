{ config, lib, ... }:
{
  options.snowflake.services.static-site = {
    enable = lib.mkEnableOption "Enable static site using nginx";
    package = lib.mkOption {
      type = lib.types.package;
      description = "Package to use as a root directory for the static site";
    };
    domain = lib.mkOption {
      type = lib.types.str;
      description = "Domain to use for the static site";
    };
  };

  config = lib.mkIf config.snowflake.services.static-site.enable {
    services.nginx = {
      virtualHosts = {
        "${config.snowflake.services.static-site.domain}" = {
          serverName = config.snowflake.services.static-site.domain;
          enableACME = true;
          forceSSL = true;
          root = config.snowflake.services.static-site.package;
        };
      };
    };
  };
}
