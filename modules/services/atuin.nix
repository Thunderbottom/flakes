{ nixos, ... }:
{
  flake.modules.nixos.atuin =
    {
      config,
      lib,
      ...
    }:
    {
      imports = [
        nixos.proxy
        nixos.postgresql
      ];

      config =
        let
          cfg = config.profile.services.atuin;
        in
        {

          services.atuin = {
            enable = true;
            inherit (cfg) port;
            openFirewall = false;
            openRegistration = false;
            database.createLocally = true;
          };

          proxy.atuin = {
            inherit (cfg) domain;
            upstream = "http://${config.services.atuin.host}:${toString config.services.atuin.port}/";
            websockets = true;
          };
        };
    };

  flake.modules.homeManager.atuin =
    {
      config,
      lib,
      ...
    }:
    {
      config = {
        programs.atuin = {
          enable = true;
          settings = {
            sync_address = "https://${config.profile.services.atuin.domain}";
            sync_frequency = "15m";
            dialect = "uk";
          };
          enableFishIntegration = true;
          flags = [ "--disable-up-arrow" ];
        };
      };
    };
}
