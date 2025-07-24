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
              Value = false;
              Status = "locked";
            };
            lock-empty-string = {
              Value = false;
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
            "browser.newtabpage.pinned" = lock-empty-string;
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
          reddit-enhancement-suite
          return-youtube-dislikes
          sponsorblock
          ublock-origin
        ];
        bookmarks = { };
        # extraConfig = builtins.readFile "${inputs.betterfox}/user.js";
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
          "browser.newtabpage.blocked" = lib.genAttrs [
            # Youtube
            "26UbzFJ7qT9/4DhodHKA1Q=="
            # Facebook
            "4gPpjkxgZzXPVtuEoAL9Ig=="
            # Wikipedia
            "eV8/WsSLxHadrTL1gAxhug=="
            # Reddit
            "gLv0ja2RYVgxKdp0I5qwvA=="
            # Amazon
            "K00ILysCaEq8+bEqV/3nuw=="
            # Twitter
            "T9nJot5PurhJSy8n038xGA=="
          ] (_: 1);

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
        };
      };
    };

    # Run firefox in wayland.
    home.sessionVariables.MOZ_ENABLE_WAYLAND = "1";
  };
}
