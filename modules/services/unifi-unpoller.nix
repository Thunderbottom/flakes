{
  flake.modules.nixos.unifi-unpoller =
    { config, lib, ... }:
    let
      cfg = {
        user = "unifi-unpoller";
        url = "https://127.0.0.1:8443";
      };
    in
    {
      config = {
        age.secrets.unpoller-password = {
          file = config.profile.secrets.services.unifi-unpoller.password.file;
          owner = config.services.prometheus.exporters.unpoller.user;
          group = config.services.prometheus.exporters.unpoller.user;
        };

        services.prometheus.exporters.unpoller = {
          enable = true;
          controllers = [
            {
              inherit (cfg) url;
              inherit (cfg) user;
              pass = config.age.secrets.unpoller-password.path;
              save_ids = true;
              save_events = true;
              save_alarms = true;
              save_anomalies = true;
              verify_ssl = false;
            }
          ];
        };
      };
    };
}
