{ nixos, ... }:
{
  flake.modules.nixos.miniflux =
    {
      config,
      lib,
      ...
    }:
    {
      imports = [
        nixos.proxy
        nixos.fail2ban
      ];

      config =
        let
          cfg = config.profile.services.miniflux;
        in
        {

          age.secrets.miniflux = {
            file = config.profile.secrets.services.miniflux.password.file;
            owner = "miniflux";
            group = "miniflux";
          };

          services.miniflux.enable = true;
          services.miniflux.adminCredentialsFile = config.age.secrets.miniflux.path;

          services.miniflux.config = {
            LISTEN_ADDR = "localhost:${toString cfg.port}";
            BASE_URL = "https://${cfg.domain}";
          };

          proxy.miniflux = {
            inherit (cfg) domain;
            upstream = "http://localhost:${toString cfg.port}";
            locationConfig = ''
              proxy_redirect off;
            '';
          };

          fail2ban.miniflux = {
            failregex = ''^.*msg="[^"]*(Incorrect|Invalid) username or password[^"]*".*client_ip=<ADDR>'';
          };
        };
    };
}
