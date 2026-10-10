{ nixos, ... }:
{
  flake.modules.nixos.qui =
    { config, ... }:
    let
      cfg = config.profile.services.qui;
    in
    {
      imports = [ nixos.backup-registry ];

      age.secrets.qui-session.file = config.profile.secrets.services.qui.session-secret.file;

      services.qui = {
        enable = true;
        secretFile = config.age.secrets.qui-session.path;
        openFirewall = true;
        settings = {
          host = "0.0.0.0";
          inherit (cfg) port;
        };
      };

      backups.qui.paths = [
        "/var/lib/${config.services.qui.user}"
      ];
    };
}
