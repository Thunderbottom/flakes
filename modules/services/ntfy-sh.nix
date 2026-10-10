{ nixos, ... }:
{
  flake.modules.nixos.ntfy-sh =
    {
      config,
      lib,
      ...
    }:
    {
      imports = [ nixos.proxy ];

      config =
        let
          cfg = config.profile.services.ntfy-sh;
        in
        {

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

          proxy.ntfy-sh = {
            inherit (cfg) domain;
            upstream = "http://${config.services.ntfy-sh.settings.listen-http}";
            locationConfig = ''
              proxy_redirect off;
              proxy_buffering off;
              proxy_request_buffering off;
              client_max_body_size 0;
            '';
          };
        };
    };
}
