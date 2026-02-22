{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.snowflake.services.forgejo;
in
lib.mkIf (cfg.enable && cfg.actions-runner.enable) {
  age.secrets.forgejo-runner = {
    inherit (cfg.actions-runner.tokenFile) file;
  };

  services.gitea-actions-runner = {
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

  systemd.services.gitea-runner-default.serviceConfig.CacheDirectory = "forgejo-runner";
}
