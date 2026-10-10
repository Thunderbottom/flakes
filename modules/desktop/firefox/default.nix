{
  flake.modules.homeManager.firefox =
    {
      config,
      inputs,
      lib,
      pkgs,
      ...
    }:
    {
      config = {
        programs.firefox = {
          enable = true;
          configPath = ".mozilla/firefox";
          package = pkgs.firefox;
          policies = import ./_policies.nix;
          profiles.ff = {
            extensions.packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
              bitwarden
              clearurls
              kagi-search
              reddit-enhancement-suite
              return-youtube-dislikes
              sponsorblock
              ublock-origin
            ];
            bookmarks = { };
            search = import ./_search.nix { inherit pkgs inputs; };
            settings = import ./_settings.nix;
          };
        };

        home.sessionVariables = {
          MOZ_WAYLAND_USE_VAAPI = "1";
        };
      };
    };
}
