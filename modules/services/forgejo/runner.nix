{ nixos, ... }:
{
  flake.modules.nixos.forgejo-runner =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.profile.services.forgejo;
    in
    {
      imports = [
        nixos.forgejo
        nixos.docker
      ];

      config = {
        age.secrets.forgejo-runner = {
          file = config.profile.secrets.services.forgejo.actions-runner.token.file;
        };

        services.gitea-actions-runner = {
          package = pkgs.forgejo-runner;
          instances.default = {
            enable = true;
            name = config.networking.hostName;
            url = "https://${cfg.domain}";
            tokenFile = config.age.secrets.forgejo-runner.path;

            labels = [
              "ubuntu-latest:docker://node:22-bookworm"
              "native:host"
            ];

            hostPackages = with pkgs; [
              bash
              coreutils
              curl
              gawk
              gitMinimal
              gnused
              nodejs
              wget
              config.nix.package
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
      };
    };
}
