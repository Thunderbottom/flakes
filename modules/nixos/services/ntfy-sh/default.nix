{
  config,
  lib,
  ...
}:
{
  options.snowflake.services.ntfy-sh = {
    enable = lib.mkEnableOption "Enable ntfy-sh service";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Configuration domain to use for the ntfy-sh service";
    };

    port = lib.mkOption {
      type = lib.types.int;
      description = "Configuration port for the ntfy-sh service to listen on";
      default = 8082;
    };
  };

  config =
    let
      cfg = config.snowflake.services.ntfy-sh;
    in
    lib.mkIf cfg.enable {
      snowflake.meta = {
        domains.list = [ cfg.domain ];
        ports.list = [ cfg.port ];
      };

      services.ntfy-sh.enable = true;
      services.ntfy-sh.settings = {
        base-url = "https://${cfg.domain}";
        upstream-base-url = "https://ntfy.sh";
        listen-http = "127.0.0.1:${toString cfg.port}";
        behind-proxy = true;

        auth-default-access = "deny-all";
        enable-login = true;
        enable-signup = false;
        enable-reservations = true;
      };

      services.nginx = {
        virtualHosts = {
          "${cfg.domain}" = {
            serverName = "${cfg.domain}";
            enableACME = true;
            forceSSL = true;
            locations."/" = {
              proxyPass = "http://${config.services.ntfy-sh.settings.listen-http}";
              extraConfig = ''
                proxy_redirect off;
                proxy_buffering off;
                proxy_request_buffering off;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;
                client_max_body_size 0;
              '';
            };
          };
        };
      };
    };
}
