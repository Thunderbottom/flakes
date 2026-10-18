{ nixos, ... }:
{
  flake.modules.nixos.jellyfin =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        nixos.proxy
        nixos.fail2ban
        nixos.backup-registry
      ];

      config =
        let
          cfg = config.profile.services.jellyfin;
        in
        {

          services.jellyfin = {
            enable = true;
            openFirewall = true;
            package = pkgs.jellyfin.override {
              jellyfin-web = pkgs.jellyfin-web.overrideAttrs (old: {
                postInstall =
                  (old.postInstall or "")
                  + (
                    let
                      abyss = pkgs.fetchFromGitHub {
                        owner = "AumGupta";
                        repo = "abyss-jellyfin";
                        tag = "v1.2.3";
                        hash = "sha256-tzXgVk1HKiBi5BAibD8LjJ/qTBEEGZjDEpV1LIOyeVg=";
                      };
                    in
                    # bash
                    ''
                      webDir="$out/share/jellyfin-web"

                      mkdir -p "$webDir/ui"
                      cp ${abyss}/scripts/spotlight/spotlight.html "$webDir/ui/"
                      cp ${abyss}/scripts/spotlight/spotlight.css  "$webDir/ui/"
                      cp ${abyss}/scripts/spotlight/home-html.chunk.js "$webDir/ui/"

                      target=$(find "$webDir" -maxdepth 1 -name 'home-html.*.chunk.js')
                      if [ -n "$target" ]; then
                        cp ${abyss}/scripts/spotlight/home-html.chunk.js "$target"
                      else
                        echo "ERROR: home-html chunk not found in $webDir" >&2
                        exit 1
                      fi
                    ''
                  );
              });
            };
          };

          users.groups.media = {
            members = [
              "@wheel"
              "jellyfin"
            ];
          };

          nixpkgs.config.packageOverrides = pkgs: {
            intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
          };

          proxy.jellyfin = {
            inherit (cfg) domain;
            upstream = "http://localhost:${toString cfg.port}/";
            websockets = true;
            locationConfig = ''
              proxy_hide_header X-Frame-Options;
            '';
          };

          backups.jellyfin.paths = [
            config.services.jellyfin.dataDir
          ];

          fail2ban.jellyfin = {
            failregex = ''^.*Authentication request for .* has been denied \(IP: "<ADDR>"\)\.'';
          };
        };
    };
}
