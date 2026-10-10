{ nixos, ... }:
{
  flake.modules.nixos.seerr =
    {
      config,
      lib,
      ...
    }:
    {
      imports = [
        nixos.proxy
        nixos.fail2ban
        nixos.backup-registry
      ];

      config =
        let
          cfg = config.profile.services.seerr;
        in
        {

          services.seerr.enable = true;
          services.seerr.openFirewall = true;

          proxy.seerr = {
            inherit (cfg) domain;
            upstream = "http://localhost:${toString cfg.port}/";
          };

          backups.seerr.paths = [
            config.services.seerr.configDir
          ];

          fail2ban.seerr = {
            failregex = ''
              ^.*\[warn\]\[API\]: Failed sign-in attempt using invalid Overseerr password {"ip":"<HOST>","email":
                ^.*\[warn\]\[Auth\]: Failed login attempt from user with incorrect Jellyfin credentials {"account":{"ip":"<HOST>","email":
            '';
          };
        };
    };
}
