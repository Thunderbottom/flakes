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
        # Clean links and per-execution directories without following store links.
        # The workflow creates the directory inside the runner's managed state.
        systemd.tmpfiles.rules = [
          "e /var/lib/forgejo-runner/default/gcroots - - - mM:30d"
        ];

        age.secrets.forgejo-runner = {
          file = config.profile.secrets.services.forgejo.actions-runner.token.file;
        };

        services.forgejo-runner = {
          instances.default = {
            enable = true;

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

              server.connections.default = {
                url = "https://${cfg.domain}";
                uuid = "5a2642c2-8f7c-45ac-b86f-92c7ad218920";
              };
              cache = {
                enabled = true;
                dir = "/var/cache/forgejo-runner/actions";
              };

              runner = {
                labels = [
                  "ubuntu-latest:docker://node:22-bookworm"
                  "native:host"
                ];
                capacity = 2;
                envs.CI_GCROOTS = "/var/lib/forgejo-runner/default/gcroots";
                timeout = "3h";
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
