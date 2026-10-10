{ nixos, ... }:
{
  # Serves this host's /nix/store as a signed binary cache.
  flake.modules.nixos.harmonia =
    { config, ... }:
    {
      imports = [ nixos.proxy ];

      config =
        let
          cfg = config.profile.services.harmonia;
        in
        {
          age.secrets.harmonia-signing-key.file = config.profile.secrets.services.harmonia.signing-key.file;

          services.harmonia.cache = {
            enable = true;
            signKeyPaths = [ config.age.secrets.harmonia-signing-key.path ];
            settings.bind = "127.0.0.1:${toString cfg.port}";
          };

          proxy.harmonia = {
            inherit (cfg) domain;
            upstream = "http://127.0.0.1:${toString cfg.port}";
          };
        };
    };
}
