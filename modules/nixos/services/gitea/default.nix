{ config, lib, ... }:
{
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
  };

  config = lib.mkIf config.snowflake.services.gitea.enable {
    age.secrets.gitea = {
      inherit (config.snowflake.services.gitea.dbPasswordFile) file;
      owner = config.services.gitea.user;
      group = config.services.gitea.user;
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
          DOMAIN = config.snowflake.services.gitea.domain;
          HTTP_ADDR = "127.0.0.1";
          HTTP_PORT = config.snowflake.services.gitea.httpPort;
          ROOT_URL = "https://${config.snowflake.services.gitea.domain}";
          SSH_DOMAIN = "https://${config.snowflake.services.gitea.sshDomain}";
          SSH_PORT = config.snowflake.services.gitea.sshPort;
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
      allowedTCPPorts = [ config.snowflake.services.gitea.sshPort ];
    };

    users.users.git = {
      description = "Gitea service user";
      home = config.services.gitea.stateDir;
      useDefaultShell = true;
      group = "git";
      isSystemUser = true;
    };
    users.groups.git = { };

    services.nginx = {
      virtualHosts = {
        "${config.snowflake.services.gitea.domain}" = {
          serverName = config.snowflake.services.gitea.domain;
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://localhost:${toString config.snowflake.services.gitea.httpPort}/";
          };
        };
      };
    };
  };
}
