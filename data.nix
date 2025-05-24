{
  secrets = {
    machines = {
      thonkpad = {
        password.file = ./secrets/machines/thonkpad/password.age;
        root-password.file = ./secrets/machines/thonkpad/root-password.age;
      };
      zippyrus = {
        password.file = ./secrets/machines/zippyrus/password.age;
        root-password.file = ./secrets/machines/zippyrus/root-password.age;
      };
      bicboye = {
        password.file = ./secrets/machines/bicboye/password.age;
        root-password.file = ./secrets/machines/bicboye/root-password.age;
      };
      smolboye = {
        password.file = ./secrets/machines/smolboye/password.age;
        root-password.file = ./secrets/machines/smolboye/root-password.age;
      };
    };
    monitoring = {
      grafana = {
        password.file = ./secrets/monitoring/grafana/password.age;
      };
    };
    nginx.ssl-environment.file = ./secrets/services/bluesky-pds/ssl-environment.age;
    services = {
      backups = {
        environment.file = ./secrets/services/backups/environment.age;
        password.file = ./secrets/services/backups/password.age;
      };
      bluesky-pds = {
        environment.file = ./secrets/services/bluesky-pds/environment.age;
      };
      forgejo = {
        password.file = ./secrets/services/forgejo/password.age;
        actions-runner.token.file = ./secrets/services/forgejo/actions-runner/token.age;
      };
      mailserver = {
        watashi.password.file = ./secrets/services/mailserver/watashi.age;
        noreply.password.file = ./secrets/services/mailserver/noreply.age;
      };
      miniflux = {
        password.file = ./secrets/services/miniflux/password.age;
      };
      paperless = {
        password.file = ./secrets/services/paperless/password.age;
      };
      unifi-unpoller = {
        password.file = ./secrets/services/unifi-unpoller/password.age;
      };
      vaultwarden = {
        password.file = ./secrets/services/vaultwarden/password.age;
      };
    };
  };
}
