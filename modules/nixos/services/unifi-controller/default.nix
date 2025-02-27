{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: {
  options.${namespace}.services.unifi-controller = {
    enable = lib.mkEnableOption "Enable Unifi controller service for Unifi devices";
    unpoller = {
      enable = lib.mkEnableOption "Enable unpoller metrics for Unifi controller";

      user = lib.mkOption {
        type = lib.types.str;
        default = "unifi-unpoller";
        description = "Username for unpoller access to Unifi controller";
      };

      passwordFile = lib.mkOption {
        description = "Age module containing the password to use for unpoller user";
      };

      url = lib.mkOption {
        type = lib.types.str;
        default = "https://127.0.0.1:8443";
        description = "URL for the unifi controller service";
      };
    };
  };

  config = let
    cfg = config.${namespace}.services.unifi-controller;
  in
    lib.mkMerge [
      (lib.mkIf cfg.enable
        {
          networking.firewall.allowedTCPPorts = [8443];
          services.unifi = {
            enable = true;
            unifiPackage = pkgs.unifi;
            mongodbPackage = pkgs.mongodb-ce;
            # Limit memory to 256MB. Works well enough
            # for small, home-based controller deployments.
            maximumJavaHeapSize = 256;
            openFirewall = true;
          };
        })

      (lib.mkIf cfg.unpoller.enable
        {
          age.secrets.unpoller-password = {
            inherit (cfg.unpoller.passwordFile) file;
            owner = config.services.prometheus.exporters.unpoller.user;
            group = config.services.prometheus.exporters.unpoller.user;
          };

          services.prometheus.exporters.unpoller = {
            enable = cfg.unpoller.enable;
            controllers = [
              {
                url = cfg.unpoller.url;
                user = cfg.unpoller.user;
                pass = config.age.secrets.unpoller-password.path;
                save_ids = true;
                save_events = true;
                save_alarms = true;
                save_anomalies = true;
                verify_ssl = false;
              }
            ];
          };
        })
    ];
}
