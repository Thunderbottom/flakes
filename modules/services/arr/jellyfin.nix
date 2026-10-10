{ nixos, ... }:
{
  flake.modules.nixos.jellyfin =
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
          cfg = config.profile.services.jellyfin;
        in
        {

          services.jellyfin = {
            enable = true;
            openFirewall = true;
          };

          users.groups.media = {
            members = [
              "@wheel"
              "jellyfin"
            ];
          };

          nixpkgs.config.packageOverrides = pkgs: {
            intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
          };

          proxy.jellyfin = {
            inherit (cfg) domain;
            upstream = "http://localhost:${toString cfg.port}/";
            websockets = true;
            locationConfig = ''
              proxy_hide_header X-Frame-Options;
            '';
          };

          backups.jellyfin.paths = [
            config.services.jellyfin.dataDir
          ];

          fail2ban.jellyfin = {
            failregex = ''^.*Authentication request for .* has been denied \(IP: "<ADDR>"\)\.'';
          };
        };
    };
}
