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
      policies = {
        AppAutoUpdate = false;
        AutofillCreditCardEnabled = false;
        DisableAppUpdate = true;
        DisableFirefoxAccounts = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DisplayBookmarksToolbar = "never";
        DisplayMenuBar = "default-off";
        DontCheckDefaultBrowser = true;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        NoDefaultBookmarks = true;
        OfferToSaveLoginsDefault = false;
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        SearchBar = "unified";
        UserMessaging = {
          ExtensionRecommendations = false;
          FeatureRecommendations = false;
          UrlbarInterventions = false;
          SkipOnboarding = true;
          MoreFromMozilla = false;
          Locked = true;
        };
        Preferences =
          let
            lock-false = {
              Value = false;
              Status = "locked";
            };
            lock-true = {
              Value = true;
              Status = "locked";
            };
          in
          {
            "toolkit.legacyUserProfileCustomizations.stylesheets" = lock-true;

            # Remove poluting defaults
            "extensions.pocket.enabled" = lock-false;

            # Remove default top sites
            "browser.topsites.contile.enabled" = lock-false;
            "browser.urlbar.suggest.topsites" = lock-false;

            # Remove sponsored sites
            "browser.newtabpage.activity-stream.showSponsored" = lock-false;
            "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
            "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;

            # Remove firefox shiny buttons
            "browser.tabs.firefox-view" = false;
            "browser.tabs.firefox-view-next" = false;
            # Style
            "browser.compactmode.show" = lock-true;
            "browser.uidensity" = {
              Value = 1;
              Status = "locked";
            };
            # Fonts - make web pages follow system font
            "browser.display.use_document_fonts" = {
              Value = 1;
              Status = "locked";
            };
          };
      };
      profiles.ff = {
        extensions.packages = with inputs.firefox-addons.packages.${pkgs.system}; [
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
        search = {
          force = true;
          default = "kagi";
          order = [
            "kagi"
            "nix-pkgs"
            "nix-options"
            "nix-wiki"
            "noogle"
          ];
          engines = {
            "nix-pkgs" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "channel";
                      value = "unstable";
                    }
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };
            "nix-options" = {
              urls = [
                {
                  template = "https://search.nixos.org/options";
                  params = [
                    {
                      name = "channel";
                      value = "unstable";
                    }
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@no" ];
            };
            "nix-wiki" = {
              urls = [
                {
                  template = "https://wiki.nixos.org/index.php";
                  params = [
                    {
                      name = "search";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [
                "@nixoswiki"
                "@nw"
              ];
            };
            "noogle" = {
              urls = [
                {
                  template = "https://noogle.dev/q";
                  params = [
                    {
                      name = "term";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [
                "@noogle"
                "@ng"
              ];
            };
            "kagi" = {
              urls = [
                {
                  template = "https://kagi.com/search";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
                {
                  template = "https://kagi.com/api/autosuggest";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                  type = "application/x-suggestions+json";
                }
              ];
              icon = "https://kagi.com/favicon.ico";
              definedAliases = [
                "@kagi"
                "@k"
              ];
            };
            wikipedia.metaData.alias = "@wiki";
            ebay-nl.metaData.hidden = true;
            ecosia.metaData.hidden = true;
            google.metaData.hidden = true;
            qwant.metaData.hidden = true;
            bing.metaData.hidden = true;
            ddg.metaData.hidden = true;
          };
        };
        settings = {
          "browser.startup.homepage" = "about:home";

          # Disable irritating first-run stuff
          "browser.disableResetPrompt" = true;
          "browser.download.panel.shown" = true;
          "browser.feeds.showFirstRunUI" = false;
          "browser.messaging-system.whatsNewPanel.enabled" = false;
          "browser.rights.3.shown" = true;
          "browser.shell.checkDefaultBrowser" = false;
          "browser.shell.defaultBrowserCheckCount" = 1;
          "browser.startup.homepage_override.mstone" = "ignore";
          "browser.uitour.enabled" = false;
          "startup.homepage_override_url" = "";
          "trailhead.firstrun.didSeeAboutWelcome" = true;
          "browser.bookmarks.restore_default_bookmarks" = false;
          "browser.bookmarks.addedImportButton" = true;

          # Don't ask for download dir
          "browser.download.useDownloadDir" = false;

          # Disable crappy home activity stream page
          "browser.newtabpage.activity-stream.feeds.topsites" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts" = false;

          # Disable some telemetry
          "app.shield.optoutstudies.enabled" = false;
          "browser.discovery.enabled" = false;
          "browser.newtabpage.activity-stream.feeds.telemetry" = false;
          "browser.newtabpage.activity-stream.telemetry" = false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          "browser.ping-centre.telemetry" = false;
          "datareporting.healthreport.service.enabled" = false;
          "datareporting.healthreport.uploadEnabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;
          "datareporting.sessions.current.clean" = true;
          "devtools.onboarding.telemetry.logged" = false;
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.bhrPing.enabled" = false;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.firstShutdownPing.enabled" = false;
          "toolkit.telemetry.hybridContent.enabled" = false;
          "toolkit.telemetry.newProfilePing.enabled" = false;
          "toolkit.telemetry.prompted" = 2;
          "toolkit.telemetry.rejected" = true;
          "toolkit.telemetry.reportingpolicy.firstRun" = false;
          "toolkit.telemetry.server" = "";
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.unifiedIsOptIn" = false;
          "toolkit.telemetry.updatePing.enabled" = false;

          # Disable fx accounts
          "identity.fxaccounts.enabled" = false;
          # Disable "save password" prompt
          "signon.rememberSignons" = false;
          # Harden
          "privacy.trackingprotection.enabled" = true;
          "privacy.donottrackheader.enabled" = true;
          "privacy.globalprivacycontrol.enabled" = true;
          "privacy.globalprivacycontrol.was_ever_enabled" = true;
          "dom.security.https_only_mode" = true;
          "browser.tabs.loadInBackground" = true;
          "gfx.webrender.enabled" = true;
          "media.eme.enabled" = true;
          "media.hardware-video-decoding.enabled" = true;

          "browser.cache.disk.enable" = true;
          "browser.cache.memory.enable" = true;
          "browser.sessionstore.restore_on_demand" = true;
          "browser.sessionstore.restore_tabs_lazily" = true;
          "nglayout.initialpaint.delay" = 0;
          "nglayout.initialpaint.delay_in_oopif" = 0;

          # Disable AI
          "browser.ml.enable" = false;

          "gfx.webrender.all" = true;
          "gfx.webrender.precache-shaders" = true;
          "gfx.canvas.accelerated" = true;
          "layers.gpu-process.enabled" = true;
          "widget.dmabuf.force-enabled" = true;

          "media.hardware-video-decoding.force-enabled" = true;
          "media.ffmpeg.vaapi.enabled" = true;
          "media.rdd-ffmpeg.enabled" = true;

          "content.notify.interval" = 100000;

          "browser.cache.jsbc_compression_level" = 3;
          "browser.cache.disk.smart_size.enabled" = false;
          "browser.cache.disk.capacity" = 1048576;
          "browser.cache.memory.capacity" = 524288;

          "media.memory_cache_max_size" = 65536;
          "media.cache_readahead_limit" = 7200;
          "media.cache_resume_threshold" = 3600;

          "image.mem.decode_bytes_at_a_time" = 131072;
          "image.mem.shared.unmap.min_expiration_ms" = 120000;

          "network.http.max-connections" = 1800;
          "network.http.max-persistent-connections-per-server" = 10;
          "network.http.max-urgent-start-excessive-connections-per-host" = 5;
          "network.http.pacing.requests.enabled" = false;
          "network.dnsCacheExpiration" = 3600;
          "network.ssl_tokens_cache_capacity" = 10240;

          "network.dns.disablePrefetch" = false;
          "network.dns.disablePrefetchFromHTTPS" = false;
          "network.prefetch-next" = true;
          "network.predictor.enabled" = true;
          "network.predictor.enable-prefetch" = true;

          "browser.sessionstore.interval" = 30000;
          "dom.ipc.processCount" = 8;

          "accessibility.force_disabled" = 1;
          "reader.parse-on-load.enabled" = false;
          "extensions.htmlaboutaddons.recommendations.enabled" = false;
          "browser.newtabpage.activity-stream.feeds.section.highlights" = false;
          "dom.enable_web_task_scheduling" = true;
        };
      };
    };

    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_WAYLAND_USE_VAAPI = "1";
    };
  };
}
