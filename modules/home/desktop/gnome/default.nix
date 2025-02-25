{
  config,
  lib,
  pkgs,
  ...
}: {
  options.snowflake.desktop.gnome-dconf.enable = lib.mkEnableOption "Enable gnome dconf home configuration";

  config = lib.mkIf config.snowflake.desktop.gnome-dconf.enable {
    dconf.settings = {
      "org/gnome/shell" = {
        favorite-apps = [
          "obsidian.desktop"
          "firefox.desktop"
          "com.mitchellh.ghostty.desktop"
        ];
        disable-user-extensions = false;
        disabled-extensions = "disabled";
        enabled-extensions = with pkgs.gnomeExtensions; [
          caffeine.extensionUuid
          dash-to-dock.extensionUuid
          appindicator.extensionUuid
          clipboard-history.extensionUuid
          just-perfection.extensionUuid
          blur-my-shell.extensionUuid
        ];
      };

      "org/gnome/desktop/wm/preferences" = {
        button-layout = "icon:minimize,maximize,close";
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = ["/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"];
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = "<Super>Return";
        command = "ghostty";
        name = "Ghostty";
      };

      "org/gnome/shell/app-switcher" = {
        current-workspace-only = false;
      };

      "org/gnome/shell/extensions/blur-my-shell" = {
        settings-version = 2;
      };

      "org/gnome/shell/extensions/blur-my-shell/appfolder" = {
        brightness = 0.6;
        sigma = 30;
      };

      "org/gnome/shell/extensions/blur-my-shell/coverflow-alt-tab" = {
        pipeline = "pipeline_default";
      };

      "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
        blur = true;
        brightness = 0.3;
        pipeline = "pipeline_default_rounded";
        sigma = 20;
        static-blur = false;
        style-dash-to-dock = 0;
      };

      "org/gnome/shell/extensions/blur-my-shell/lockscreen" = {
        pipeline = "pipeline_default";
      };

      "org/gnome/shell/extensions/blur-my-shell/overview" = {
        pipeline = "pipeline_default";
      };

      "org/gnome/shell/extensions/blur-my-shell/panel" = {
        brightness = 0.3;
        pipeline = "pipeline_default";
        sigma = 10;
        static-blur = false;
      };

      "org/gnome/shell/extensions/blur-my-shell/screenshot" = {
        pipeline = "pipeline_default";
      };

      "org/gnome/shell/extensions/blur-my-shell/window-list" = {
        brightness = 0.6;
        sigma = 25;
      };

      "org/gnome/shell/extensions/caffeine" = {
        indicator-position-max = 2;
      };

      "org/gnome/shell/extensions/clipboard-history" = {
        history-size = 10;
      };

      "org/gnome/shell/extensions/dash-to-dock" = {
        apply-custom-theme = true;
        background-opacity = 0.8;
        custom-theme-shrink = true;
        dash-max-icon-size = 48;
        dock-position = "BOTTOM";
        height-fraction = 0.9;
        intellihide-mode = "FOCUS_APPLICATION_WINDOWS";
        preferred-monitor = -2;
        preferred-monitor-by-connector = "eDP-1";
      };

      "org/gnome/shell/extensions/just-perfection" = {
        accessibility-menu = true;
        dash = true;
        dash-icon-size = 0;
        max-displayed-search-results = 0;
        panel = true;
        panel-in-overview = true;
        ripple-box = true;
        search = true;
        show-apps-button = true;
        startup-status = 0;
        support-notifier-showed-version = 34;
        support-notifier-type = 0;
        theme = true;
        window-demands-attention-focus = false;
        window-picker-icon = true;
        workspace = true;
        workspace-wrap-around = true;
        workspaces-in-app-grid = true;
      };

      "org/gnome/shell/world-clocks" = {
        locations = [];
      };

      "org/gnome/tweaks" = {
        show-extensions-notice = false;
      };

      "org/gnome/mutter".experimental-features = ["scale-monitor-framebuffer"];

      "org/gnome/desktop/peripherals/mouse" = {
        accel-profile = "flat";
        natural-scoll = false;
      };

      "org/gnome/desktop/peripherals/touchpad".tap-to-click = true;
      "org/gnome/desktop/interface".show-battery-percentage = true;
      "org/gnome/desktop/wm/keybindings".close = ["<Super>q"];

      "org/gnome/settings-daemon/plugins/media-keys".search = ["<Super>d"];
    };

    gtk = {
      enable = true;
      iconTheme = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
      };
    };
  };
}
