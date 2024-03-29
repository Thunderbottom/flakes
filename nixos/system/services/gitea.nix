{config, ...}: let
  domain = "git.deku.moe";
  sshDomain = "git-ssh.deku.moe";
  httpPort = 3001;
  sshPort = 22022;
in {
  age.secrets.gitea = {
    file = ../../../secrets/gitea.age;
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
      user = config.services.gitea.user;
    };

    settings = {
      actions = {
        ENABLED = true;
      };
      picture = {
        DISABLE_GRAVATAR = true;
      };
      server = {
        DOMAIN = domain;
        HTTP_ADDR = "127.0.0.1";
        HTTP_PORT = httpPort;
        ROOT_URL = "https://${domain}/";
        SSH_DOMAIN = sshDomain;
        SSH_PORT = sshPort;
      };
      service = {
        DISABLE_REGISTRATION = true;
        SHOW_REGISTRATION_BUTTON = false;
      };
      session = {
        COOKIE_SECURE = true;
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

  users.users.git = {
    description = "Gitea Service";
    home = config.services.gitea.stateDir;
    useDefaultShell = true;
    group = "git";
    isSystemUser = true;
  };
  users.groups.git = {};

  services.nginx = {
    virtualHosts = {
      "${domain}" = {
        serverName = "${domain}";
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:${toString httpPort}/";
        };
      };
    };
  };
}
