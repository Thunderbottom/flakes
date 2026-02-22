{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  options.snowflake.desktop.firefox.enable = lib.mkEnableOption "Enable firefox home configuration";

  config = lib.mkIf config.snowflake.desktop.firefox.enable {
    programs.firefox = {
      enable = true;
      package = pkgs.firefox;
      policies = import ./policies.nix;
      profiles.ff = {
        extensions.packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
          bitwarden
          clearurls
          consent-o-matic
          duckduckgo-privacy-essentials
          kagi-search
          reddit-enhancement-suite
          return-youtube-dislikes
          sponsorblock
          ublock-origin
        ];
        bookmarks = { };
        search = import ./search.nix { inherit pkgs inputs; };
        settings = import ./settings.nix;
      };
    };

    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_WAYLAND_USE_VAAPI = "1";
    };
  };
}
