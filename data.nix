{
  secrets = {
    machines = {
      thonkpad = {
        password.file = ./secrets/machines/thonkpad/password.age;
        root-password.file = ./secrets/machines/thonkpad/root-password.age;
      };
      bicboye = {
        password.file = ./secrets/machines/bicboye/password.age;
        root-password.file = ./secrets/machines/bicboye/root-password.age;
      };
    };
    monitoring = {
      grafana = {
        password.file = ./secrets/monitoring/grafana/password.age;
      };
    };
    services = {
      gitea = {
        password.file = ./secrets/services/gitea/password.age;
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
