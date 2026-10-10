# A blank feature module. Copy it to `modules/<group>/<name>.nix`, it is loaded automatically.
# Shared values come from `config.profile`. Reverse proxies go in `proxy.<name>` and
# backup paths in `backups.<name>.paths`. Add `flake.modules.homeManager.<name>` next
# to the NixOS part if there is one.
{ nixos, ... }:
{
  flake.modules.nixos.my-module =
    { config, ... }:
    let
      cfg = config.profile.services.my-module;
    in
    {
      # Other features this one needs, so hosts only list what they want.
      imports = [
        nixos.proxy
        nixos.backup-registry
      ];

      services.my-module = {
        enable = true;
        inherit (cfg) port;
      };

      proxy.my-module = {
        inherit (cfg) domain;
        upstream = "http://localhost:${toString cfg.port}/";
      };

      backups.my-module.paths = [ "/var/lib/my-module" ];
    };
}
