{ nixos, ... }:
{
  flake.modules.nixos.gnome =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [ nixos.desktop ];

      config = {
        services.speechd.enable = false;

        services = {
          displayManager.gdm = {
            enable = true;
          };
          desktopManager.gnome = {
            enable = true;
            extraGSettingsOverridePackages = [
              pkgs.nautilus-open-any-terminal
              pkgs.mutter
            ];
          };
        };

        services.udev.packages = [ pkgs.gnome-settings-daemon ];

        environment = {
          gnome.excludePackages = with pkgs; [
            atomix # puzzle game
            baobab
            cheese # webcam tool
            epiphany # web browser
            geary # email reader
            gedit
            gnome-characters
            gnome-connections
            gnome-console
            gnome-contacts
            gnome-font-viewer
            gnome-initial-setup
            gnome-logs
            gnome-maps
            gnome-music
            gnome-shell-extensions
            gnome-software
            gnome-terminal
            gnome-text-editor
            gnome-tour
            gnome-user-docs
            gnome-weather
            hitori # sudoku game
            iagno # go game
            loupe
            orca
            simple-scan
            snapshot
            tali # poker game
            totem # video player
            yelp # Help view
          ];

          systemPackages = with pkgs; [
            ffmpegthumbnailer
            adwaita-icon-theme
            gnome-tweaks
            nautilus-python
            nautilus-open-any-terminal
            wl-clipboard

            gnomeExtensions.caffeine
            gnomeExtensions.dash-to-dock
            gnomeExtensions.appindicator
            gnomeExtensions.clipboard-history
            gnomeExtensions.just-perfection
          ];
        };

        xdg.portal.extraPortals = with pkgs; [
          xdg-desktop-portal-gnome
        ];

        systemd.tmpfiles.rules = [ "d ${config.users.users.gdm.home}/.config 0711 gdm gdm" ];

        users.users.${config.profile.username}.extraGroups = [
          "audio"
          "input"
          "video"
        ];
      };
    };

  flake.modules.homeManager.gnome-dconf =
    {
      config,
      inputs,
      lib,
      pkgs,
      ...
    }:
    {
      config = {
        home.pointerCursor = {
          enable = true;
          package = pkgs.bibata-cursors;
          name = "Bibata-Modern-Classic";
          size = 24;
          gtk.enable = true;
        };

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
            ];
          };

          "org/gnome/desktop/break-reminders" = {
            selected-breaks = [ "eyesight" ];
          };

          "org/gnome/desktop/wm/preferences" = {
            button-layout = "icon:minimize,maximize,close";
          };

          "org/gnome/settings-daemon/plugins/media-keys" = {
            custom-keybindings = [
              "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
            ];
          };

          "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
            binding = "<Super>Return";
            command = "${pkgs.ghostty}/bin/ghostty";
            name = "Ghostty";
          };

          "org/gnome/shell/app-switcher" = {
            current-workspace-only = false;
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
            intellihide-mode = "MAXIMIZED_WINDOWS";
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
            locations = [ ];
          };

          "org/gnome/tweaks" = {
            show-extensions-notice = false;
          };

          "org/gnome/mutter".experimental-features = [
            "scale-monitor-framebuffer"
            "kms-modifiers"
            "autoclose-xwayland"
          ];

          "org/gnome/desktop/peripherals/mouse" = {
            accel-profile = "flat";
            natural-scoll = false;
            speed = 0.8;
          };

          "org/gnome/desktop/peripherals/touchpad".tap-to-click = true;
          "org/gnome/desktop/interface".show-battery-percentage = true;
          "org/gnome/desktop/wm/keybindings".close = [ "<Super>q" ];

          "org/gnome/settings-daemon/plugins/media-keys".search = [ "<Super>d" ];
        };

        gtk = {
          enable = true;
          iconTheme = {
            package = pkgs.adwaita-icon-theme;
            name = "Adwaita";
          };
        };
      };
    };
}
