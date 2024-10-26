{
  config,
  lib,
  ...
}: {
  options.snowflake.services.gitea = {
    enable = lib.mkEnableOption "Enable gitea service";

    domain = lib.mkOption {
      type = lib.types.str;
      description = "Configuration domain to use for the gitea service";
    };

    sshDomain = lib.mkOption {
      type = lib.types.str;
      description = "SSH domain to use for the gitea service";
    };

    dbPasswordFile = lib.mkOption {
      description = "Age module containing the postgresql password to use for gitea";
    };

    httpPort = lib.mkOption {
      type = lib.types.int;
      description = "Configuration port for the gitea service to listen on";
      default = 3001;
    };

    sshPort = lib.mkOption {
      type = lib.types.int;
      description = "SSH port for the gitea service to listen on";
      default = 22022;
    };

    actions-runner = {
      enable = lib.mkEnableOption "Enable a single-instance of gitea-actions-runner";
      tokenFile = lib.mkOption {
        description = "Age module containing the token to use for gitea-actions-runner";
      };
    };
  };

  config = let
    cfg = config.snowflake.services.gitea;
  in
    lib.mkIf cfg.enable {
      age.secrets = {
        gitea = {
          inherit (cfg.dbPasswordFile) file;
          owner = config.services.gitea.user;
          group = config.services.gitea.user;
        };

        gitea-actions-runner = lib.mkIf cfg.actions-runner.enable {
          inherit (cfg.actions-runner.tokenFile) file;
        };
      };

      services.gitea = {
        enable = true;
        lfs.enable = true;
        user = "git";

        database = {
          type = "postgres";
          passwordFile = config.age.secrets.gitea.path;
          name = config.services.gitea.user;
          inherit (config.services.gitea) user;
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

      services.gitea-actions-runner = {
        instances.default = {
          enable = cfg.actions-runner.enable;
          name = config.networking.hostName;
          url = "https://${cfg.domain}";
          tokenFile = config.age.secrets.gitea-actions-runner.path;

          labels = [
            "ubuntu-latest:docker://node:22-bookworm"
          ];

          settings = {
            log.level = "info";

            cache = {
              enabled = true;
              dir = "/var/cache/gitea-runner/actions";
            };

            runner = {
              capacity = 2;
              envs = {};
              timeout = "1h";
            };

            container = {
              network = "bridge";
              privileged = "false";
              docker_host = "";
            };
            host.workdir_parent = "/var/tmp/gitea-actions-work";
          };
        };
      };

      systemd.services.gitea-runner-default.serviceConfig.CacheDirectory = "gitea-runner";

      networking.firewall = lib.mkIf config.networking.firewall.enable {
        allowedTCPPorts = [cfg.sshPort];
      };

      users.users.git = {
        description = "Gitea service user";
        home = config.services.gitea.stateDir;
        useDefaultShell = true;
        group = "git";
        isSystemUser = true;
      };
      users.groups.git = {};

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

      snowflake.services.backups.config.gitea.paths = [
        config.services.gitea.repositoryRoot
        config.services.gitea.lfs.contentDir
      ];

      services.fail2ban.jails.gitea = {
        enabled = true;
        filter = "gitea";
      };

      environment.etc = {
        gitea = {
          target = "fail2ban/filter.d/gitea.conf";
          text = ''
            [Definition]
            failregex =  .*(Failed authentication attempt|invalid credentials|Attempted access of unknown user).* from <HOST>
            ignoreregex =
            journalmatch = _SYSTEMD_UNIT=gitea.service
          '';
        };
      };
    };
}
