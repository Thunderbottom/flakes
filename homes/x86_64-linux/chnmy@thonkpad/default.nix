{
  config,
  inputs,
  pkgs,
  ...
}: {
  snowfallorg.user.enable = true;
  snowfallorg.user.name = "chnmy";

  snowflake.desktop.wezterm.enable = true;

  snowflake.development.git.enable = true;
  snowflake.development.git.user = {
    name = "Chinmay D. Pai";
    email = "chinmaydpai@gmail.com";
    signingKey = "75507BE256F40CED";
  };
  snowflake.development.git.work = {
    enable = true;
    email = "chinmay.pai@zerodha.com";
    path = "/home/${config.snowfallorg.user.name}/workspace/gitlab.zerodha.tech";
    extraConfig = {
      url."ssh://git@gitlab.zerodha.tech:2280".insteadOf = "https://gitlab.zerodha.tech";
      url."ssh://git@gitlab.zerodha.tech:2280/".insteadOf = "git@gitlab.zerodha.tech:";
    };
  };

  snowflake.development.helix.enable = true;
  snowflake.development.tmux.enable = true;
  snowflake.shell.fish.enable = true;

  programs.firefox = {
    enable = true;
    package = inputs.firefox.packages.${pkgs.system}.firefox-nightly-bin.override {
      cfg = {
        pipewireSupport = true;
      };
    };
    # extensions = with config.nur.repos.rycee.firefox-addons; [
    #   bitwarden
    #   clearurls
    #   duckduckgo-privacy-essentials
    #   reddit-enhancement-suite
    #   sponsorblock
    #   ublock-origin
    # ];
    # policies = {
    #   DisableFirefoxStudies = true;
    #   EnableTrackingProtection = {
    #     Value = true;
    #     Locked = true;
    #     Cryptomining = true;
    #     Fingerprinting = true;
    #   };
    #   OfferToSaveLoginsDefault = false;

    #   DisableTelemetry = true;
    #   DisablePocket = true;
    #   DisableFirefoxAccounts = true;
    #   OverrideFirstRunPage = "";
    #   OverridePostUpdatePage = "";
    #   DontCheckDefaultBrowser = true;
    #   DisplayMenuBar = "default-off";
    #   SearchBar = "unified";
    #   NoDefaultBookmarks = true;
    #   DisplayBookmarksToolbar = "never";
    #   Preferences = let
    #     lock-false = {
    #       Value = false;
    #       Status = "locked";
    #     };
    #     lock-true = {
    #       Value = false;
    #       Status = "locked";
    #     };
    #     lock-empty-string = {
    #       Value = false;
    #       Status = "locked";
    #     };
    #   in {
    #     "toolkit.legacyUserProfileCustomizations.stylesheets" = lock-true;

    #     # Remove poluting defaults
    #     "extensions.pocket.enabled" = lock-false;

    #     # Remove default top sites
    #     "browser.topsites.contile.enabled" = lock-false;
    #     "browser.urlbar.suggest.topsites" = lock-false;

    #     # Remove sponsored sites
    #     "browser.newtabpage.pinned" = lock-empty-string;
    #     "browser.newtabpage.activity-stream.showSponsored" = lock-false;
    #     "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
    #     "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;

    #     # Remove firefox shiny buttons
    #     "browser.tabs.firefox-view" = false;
    #     "browser.tabs.firefox-view-next" = false;
    #     # Style
    #     "browser.compactmode.show" = lock-true;
    #     "browser.uidensity" = {
    #       Value = 1;
    #       Status = "locked";
    #     };
    #     # Fonts - make web pages follow system font
    #     "browser.display.use_document_fonts" = {
    #       Value = 0;
    #       Status = "locked";
    #     };

    #     "browser.tabs.loadInBackground" = true;
    #     "gfx.canvas.accelerated" = true;
    #     "gfx.webrender.enabled" = true;
    #     "gfx.x11-egl.force-enabled" = true;
    #     "layers.acceleration.force-enabled" = true;
    #     "media.av1.enabled" = false;
    #     "media.ffmpeg.vaapi.enabled" = true;
    #     "media.hardware-video-decoding.force-enabled" = true;
    #     "media.rdd-ffmpeg.enabled" = true;
    #     "widget.dmabuf.force-enabled" = true;
    #     "svg.context-properties.content.enabled" = true;
    #     "gnomeTheme.hideSingleTab" = true;
    #     "gnomeTheme.bookmarksToolbarUnderTabs" = true;
    #     "gnomeTheme.normalWidthTabs" = false;
    #     "gnomeTheme.tabsAsHeaderbar" = false;
    #   };
    # };
  };

  home.packages = [
    pkgs.mpv
  ];

  home.stateVersion = "24.05";
}
