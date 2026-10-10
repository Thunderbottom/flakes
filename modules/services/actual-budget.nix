{ nixos, ... }:
{
  flake.modules.nixos.actual-budget =
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
          cfg = config.profile.services.actual;
        in
        {

          services.actual = {
            enable = true;
            settings = {
              inherit (cfg) port;
            };
          };

          proxy.actual-budget = {
            inherit (cfg) domain;
            upstream = "http://127.0.0.1:${toString config.services.actual.settings.port}/";
            websockets = true;
          };

          backups.actual-budget.paths = [
            config.services.actual.settings.dataDir
          ];
        };
    };
}
