{
  config,
  lib,
  pkgs,
  ...
}: {
  options.snowflake.desktop.gnome = {
    enable = lib.mkEnableOption "Enable the Gnome Desktop Environment";
  };

  config = lib.mkIf config.snowflake.desktop.gnome.enable {
    services.xserver = {
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
      desktopManager.gnome = {
        enable = true;
        extraGSettingsOverridePackages = [
          pkgs.nautilus-open-any-terminal
        ];
      };
    };

    services.udev.packages = [pkgs.gnome-settings-daemon];

    # Remove bloatware that we do not require.
    environment = {
      gnome.excludePackages = with pkgs; [
        atomix # puzzle game
        cheese # webcam tool
        epiphany # web browser
        evince # document viewer
        geary # email reader
        gedit
        gnome-characters
        gnome-connections
        gnome-console
        gnome-contacts
        gnome-font-viewer
        gnome-initial-setup
        gnome-maps
        gnome-music
        gnome-photos
        gnome-shell-extensions
        gnome-text-editor
        gnome-tour
        hitori # sudoku game
        iagno # go game
        snapshot
        tali # poker game
        totem # video player
        yelp # Help view
      ];

      systemPackages = with pkgs; [
        ffmpegthumbnailer
        adwaita-icon-theme
        bibata-cursors
        dconf-editor
        gnome-tweaks
        nautilus-python
        nautilus-open-any-terminal
        wl-clipboard
      ];
    };

    programs.dconf.profiles = {
      gdm.databases = [
        {
          settings = {
            "org/gnome/mutter".experimental-features = ["scale-monitor-framebuffer"];
            "org/gnome/desktop/peripherals/mouse".accel-profile = "flat";
            "org/gnome/desktop/peripherals/touchpad".tap-to-click = true;
          };
        }
      ];
    };

    snowflake.user.extraGroups = [
      "audio"
      "input"
      "video"
    ];
  };
}
