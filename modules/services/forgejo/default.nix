{ nixos, ... }:
{
  flake.modules.nixos.forgejo =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        nixos.proxy
        nixos.postgresql
        nixos.fail2ban
        nixos.backup-registry
      ];

      config =
        let
          cfg = config.profile.services.forgejo;
        in
        {

          age.secrets.forgejo = {
            file = config.profile.secrets.services.forgejo.password.file;
            owner = config.services.forgejo.user;
            group = config.services.forgejo.user;
          };

          services.forgejo = {
            enable = true;
            lfs.enable = true;
            package = pkgs.forgejo;
            user = "git";

            database = {
              type = "postgres";
              passwordFile = config.age.secrets.forgejo.path;
              name = config.services.forgejo.user;
              inherit (config.services.forgejo) user;
            };

            settings = {
              actions = {
                ENABLED = true;
              };
              picture = {
                DISABLE_GRAVATAR = true;
              };
              server = {
                DOMAIN = cfg.domain;
                HTTP_ADDR = "127.0.0.1";
                HTTP_PORT = cfg.port;
                ROOT_URL = "https://${cfg.domain}";
                SSH_DOMAIN = cfg.sshDomain;
                SSH_PORT = cfg.sshPort;
              };
              service = {
                DISABLE_REGISTRATION = true;
                SHOW_REGISTRATION_BUTTON = false;
              };
              security = {
                LOGIN_REMEMBER_DAYS = 14;
                MIN_PASSWORD_LENGTH = 12;
                PASSWORD_COMPLEXITY = "lower,upper,digit,spec";
                PASSWORD_CHECK_PWN = true;
              };
              other = {
                SHOW_FOOTER_VERSION = false;
                SHOW_FOOTER_TEMPLATE_LOAD_TIME = false;
              };
            };
          };

          networking.firewall = lib.mkIf config.networking.firewall.enable {
            allowedTCPPorts = [ cfg.sshPort ];
          };

          users.users.git = {
            description = "Forgejo service user";
            home = config.services.forgejo.stateDir;
            useDefaultShell = true;
            group = "git";
            isSystemUser = true;
          };
          users.groups.git = { };

          proxy.forgejo = {
            inherit (cfg) domain;
            upstream = "http://localhost:${toString cfg.port}/";
          };

          backups.forgejo.paths = [
            config.services.forgejo.stateDir
          ];

          fail2ban.forgejo = {
            failregex = ".*(Failed authentication attempt|invalid credentials|Attempted access of unknown user).* from <HOST>";
          };
        };
    };
}
