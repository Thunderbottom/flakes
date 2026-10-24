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

        services.forgejo-runner = {
          instances.default = {
            enable = true;
            url = "https://${cfg.domain}";

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

            secrets.server.connections.default.token_url = config.age.secrets.forgejo-runner.path;

            settings = {
              log.level = "info";

              server.connections.default.uuid = "5a2642c2-8f7c-45ac-b86f-92c7ad218920";
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
      };
    };
}
