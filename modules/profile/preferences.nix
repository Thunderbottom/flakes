{ inputs, ... }:
let
  secretsDir = "${inputs.self}/secrets";

  # `secrets/services/foo/password.age` becomes `secrets.services.foo.password.file`.
  mkSecrets =
    lib: dir:
    lib.concatMapAttrs (
      name: type:
      if type == "directory" then
        { ${name} = mkSecrets lib "${dir}/${name}"; }
      else if lib.hasSuffix ".age" name then
        { ${lib.removeSuffix ".age" name}.file = "${dir}/${name}"; }
      else
        { }
    ) (builtins.readDir dir);
in
{
  flake.modules.generic.profile =
    { lib, ... }:
    let
      domain = "deku.moe";

      # Domain and port of each self-hosted service. Unique across the registry
      # (asserted in `nixos.base`).
      services = {
        actual = {
          subdomain = "actual";
          port = 5006;
        };
        atuin = {
          subdomain = "atuin";
          port = 8888;
        };
        audiobookshelf.subdomain = "books";
        bluesky-pds.subdomain = "blue";
        cross-seed.port = 2468;
        forgejo = {
          subdomain = "git";
          port = 3001;
          sshSubdomain = "git-ssh";
          sshPort = 22022;
        };
        grafana = {
          subdomain = "lens";
          port = 3010;
        };
        harmonia = {
          subdomain = "cache";
          port = 5000;
        };
        immich = {
          subdomain = "photos";
          port = 9121;
        };
        jellyfin = {
          subdomain = "jelly";
          port = 8096;
        };
        miniflux = {
          subdomain = "flux";
          port = 8816;
        };
        navidrome = {
          subdomain = "music";
          port = 4533;
        };
        ntfy-sh = {
          subdomain = "ntfy";
          port = 8082;
        };
        paperless = {
          subdomain = "docs";
          port = 28981;
        };
        qbittorrent = {
          port = 8069;
          torrentPort = 64211;
        };
        qui.port = 7476;
        seerr = {
          subdomain = "seerr";
          port = 5055;
        };
        vaultwarden = {
          subdomain = "bw";
          port = 33003;
        };
        victoriametrics.port = 8428;
      };

      withDomains = lib.mapAttrs (
        _: s:
        lib.removeAttrs s [
          "subdomain"
          "sshSubdomain"
        ]
        // lib.optionalAttrs (s ? subdomain) { domain = "${s.subdomain}.${domain}"; }
        // lib.optionalAttrs (s ? sshSubdomain) { sshDomain = "${s.sshSubdomain}.${domain}"; }
      );
    in
    {
      options.profile = lib.mkOption {
        type = lib.types.lazyAttrsOf lib.types.anything;
        default = { };
      };

      config.profile = lib.mapAttrsRecursive (_: lib.mkDefault) {
        username = "chnmy";
        fullName = "Chinmay D. Pai";
        email = "chinmaydpai@gmail.com";
        gitKey = "75507BE256F40CED";

        inherit domain;
        services = withDomains services;

        backupRepository = "b2:restic-nix";

        wifi.networks = {
          "The Y-Fi" = "$THE_YFI_PSK";
          "The Y-Fi 2.4" = "$THE_YFI_PSK";
          "The Y-Fi Inside" = "$THE_YFI_PSK";
        };

        timezone = "Europe/Madrid";
        locale = "en_US.UTF-8";

        sshKeys = import ./_ssh-keys.nix;
        secrets = mkSecrets lib secretsDir;
      };
    };
}
