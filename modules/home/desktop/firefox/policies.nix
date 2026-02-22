{
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
}
