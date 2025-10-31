{
  config,
  lib,
  ...
}:
{
  options.snowflake.services.audiobookshelf = {
    enable = lib.mkEnableOption "Enable audiobookshelf deployment configuration";
    domain = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Configuration domain to use for the audiobookshelf service";
    };
  };

  config =
    let
      cfg = config.snowflake.services.audiobookshelf;
    in
    lib.mkIf cfg.enable {
      snowflake.meta = {
        domains.list = [ cfg.domain ];
        ports.list = [ config.services.audiobookshelf.port ];
      };
      services.audiobookshelf = {
        enable = true;
        openFirewall = true;
        group = "media";
      };

      users.groups.media = {
        members = [
          "@wheel"
          "audiobookshelf"
        ];
      };

      services.nginx = {
        virtualHosts = {
          "${cfg.domain}" = {
            serverName = cfg.domain;
            enableACME = true;
            forceSSL = true;
            locations."/" = {
              proxyWebsockets = true;
              proxyPass = "http://localhost:${toString config.services.audiobookshelf.port}/";
              extraConfig = ''
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;

                client_max_body_size 10240M;
              '';
            };
          };
        };
      };

      snowflake.services.backups.config.audiobookshelf.paths = [
        config.services.audiobookshelf.dataDir
      ];
    };
}
