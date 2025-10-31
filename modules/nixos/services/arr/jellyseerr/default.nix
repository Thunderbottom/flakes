{
  config,
  lib,
  ...
}:
{
  options.snowflake.services.jellyseerr = {
    enable = lib.mkEnableOption "Enable jellyseerr deployment configuration";
    domain = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Configuration domain to use for the jellyseerr service";
    };
    port = lib.mkOption {
      type = lib.types.port;
      default = 5055;
      description = "Configuration port to use for the jellyseerr service";
    };
  };

  config =
    let
      cfg = config.snowflake.services.jellyseerr;
    in
    lib.mkIf cfg.enable {
      snowflake.meta = {
        domains.list = [ cfg.domain ];
        ports.list = [ cfg.port ];
      };
      services.jellyseerr.enable = true;
      services.jellyseerr.openFirewall = true;

      services.nginx = {
        virtualHosts = {
          "${cfg.domain}" = {
            serverName = cfg.domain;
            enableACME = true;
            forceSSL = true;
            locations."/" = {
              proxyPass = "http://localhost:${toString cfg.port}/";
            };
          };
        };
      };

      snowflake.services.backups.config.jellyseerr.paths = [
        config.services.jellyseerr.configDir
      ];

      environment.etc = {
        jellyseerr = {
          target = "fail2ban/filter.d/jellyseerr.conf";
          text = ''
            [INCLUDES]
            before = common.conf

            [Definition]
            failregex = ^.*\[warn\]\[API\]: Failed sign-in attempt using invalid Overseerr password {"ip":"<HOST>","email":
                        ^.*\[warn\]\[Auth\]: Failed login attempt from user with incorrect Jellyfin credentials {"account":{"ip":"<HOST>","email":
            ignoreregex =
            journalmatch = _SYSTEMD_UNIT=jellyseerr.service
          '';
        };
      };
    };
}
