{ nixos, ... }:
{
  flake.modules.nixos.audiobookshelf =
    {
      config,
      lib,
      ...
    }:
    {
      imports = [
        nixos.proxy
        nixos.backup-registry
      ];

      config =
        let
          cfg = config.profile.services.audiobookshelf;
        in
        {

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

          proxy.audiobookshelf = {
            inherit (cfg) domain;
            upstream = "http://localhost:${toString config.services.audiobookshelf.port}/";
            websockets = true;
            locationConfig = ''
              client_max_body_size 10240M;
            '';
          };

          backups.audiobookshelf.paths = [
            config.services.audiobookshelf.dataDir
          ];
        };
    };
}
