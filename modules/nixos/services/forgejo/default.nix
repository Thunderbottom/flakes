{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.snowflake.services.forgejo = {
    enable = lib.mkEnableOption "Enable forgejo service";

    domain = lib.mkOption {
      type = lib.types.str;
      description = "Configuration domain to use for the forgejo service";
      default = "";
    };

    sshDomain = lib.mkOption {
      type = lib.types.str;
      description = "SSH domain to use for the forgejo service";
      default = config.snowflake.services.forgejo.domain;
      defaultText = "config.snowflake.services.forgejo.domain";
    };

    dbPasswordFile = lib.mkOption {
      description = "Age module containing the postgresql password to use for forgejo";
    };

    httpPort = lib.mkOption {
      type = lib.types.int;
      description = "Configuration port for the forgejo service to listen on";
      default = 3001;
    };

    sshPort = lib.mkOption {
      type = lib.types.int;
      description = "SSH port for the forgejo service to listen on";
      default = 22022;
    };

    actions-runner = {
      enable = lib.mkEnableOption "Enable a single-instance of forgejo-runner";
      tokenFile = lib.mkOption {
        description = "Age module containing the token to use for forgejo-runner";
      };
    };
  };

  config =
    let
      cfg = config.snowflake.services.forgejo;
    in
    lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.domain != "";
          message = "snowflake.services.forgejo.domain must not be empty";
        }
      ];

      warnings =
        if cfg.sshDomain == cfg.domain then
          [
            ''
              No unique value specified for `snowflake.services.forgejo.sshDomain`.
              Will default to snowflake.services.forgejo.domain. This might cause
              issues with SSH if the forgejo service is behind a proxy, like CloudFlare.
            ''
          ]
        else
          [ ];

      snowflake.meta = {
        domains.list = [
          cfg.domain
          cfg.sshDomain
        ];
        ports.list = [
          cfg.httpPort
          cfg.sshPort
        ];
      };

      age.secrets = {
        forgejo = {
          inherit (cfg.dbPasswordFile) file;
          owner = config.services.forgejo.user;
          group = config.services.forgejo.user;
        };

        forgejo-runner = lib.mkIf cfg.actions-runner.enable {
          inherit (cfg.actions-runner.tokenFile) file;
        };
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
            HTTP_PORT = cfg.httpPort;
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

      services.gitea-actions-runner = lib.mkIf cfg.actions-runner.enable {
        package = pkgs.forgejo-runner;
        instances.default = {
          inherit (cfg.actions-runner) enable;
          name = config.networking.hostName;
          url = "https://${cfg.domain}";
          tokenFile = config.age.secrets.forgejo-runner.path;

          labels = [
            "ubuntu-latest:docker://node:22-bookworm"
          ];

          settings = {
            log.level = "info";

            cache = {
              enabled = true;
              dir = "/var/cache/forgejo-runner/actions";
            };

            runner = {
              capacity = 2;
              envs = { };
              timeout = "1h";
            };

            container = {
              network = "bridge";
              privileged = false;
              docker_host = "";
            };
            host.workdir_parent = "/var/tmp/forgejo-actions-work";
          };
        };
      };

      systemd.services.gitea-runner-default.serviceConfig.CacheDirectory =
        lib.mkIf cfg.actions-runner.enable "forgejo-runner";

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

      services.nginx = {
        virtualHosts = {
          "${cfg.domain}" = {
            serverName = cfg.domain;
            enableACME = true;
            forceSSL = true;
            locations."/" = {
              proxyPass = "http://localhost:${toString cfg.httpPort}/";
            };
          };
        };
      };

      snowflake.services.backups.config.forgejo.paths = [
        config.services.forgejo.stateDir
      ];

      services.fail2ban.jails.forgejo = {
        enabled = true;
        filter = "forgejo";
      };

      environment.etc = {
        forgejo = {
          target = "fail2ban/filter.d/forgejo.conf";
          text = ''
            [Definition]
            failregex =  .*(Failed authentication attempt|invalid credentials|Attempted access of unknown user).* from <HOST>
            ignoreregex =
            journalmatch = _SYSTEMD_UNIT=forgejo.service
          '';
        };
      };
    };
}
