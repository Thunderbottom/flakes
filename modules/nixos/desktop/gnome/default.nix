{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
{
  options.${namespace}.desktop.gnome = {
    enable = lib.mkEnableOption "Enable the Gnome Desktop Environment";
    monitors.xml = lib.mkOption {
      default = "";
      description = "The monitors.xml configuration to use for gdm";
      type = lib.types.str;
    };
  };

  config = lib.mkIf config.${namespace}.desktop.gnome.enable {
    services = {
      displayManager.gdm = {
        enable = true;
        wayland = true;
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
        adwaita-icon-theme-legacy
        bibata-cursors
        dconf-editor
        gnome-tweaks
        nautilus-python
        nautilus-open-any-terminal
        wl-clipboard

        gnomeExtensions.caffeine
        gnomeExtensions.dash-to-dock
        gnomeExtensions.appindicator
        gnomeExtensions.clipboard-history
        gnomeExtensions.just-perfection
        gnomeExtensions.blur-my-shell
      ];
    };

    systemd.tmpfiles.rules =
      let
        monitors.xml = pkgs.writeText "monitors.xml" config.${namespace}.desktop.gnome.monitors.xml;
      in
      [ "d ${config.users.users.gdm.home}/.config 0711 gdm gdm" ]
      ++ (lib.optional (
        config.${namespace}.desktop.gnome.monitors.xml != ""
      ) "L+ ${config.users.users.gdm.home}/.config/monitors.xml - gdm gdm - ${monitors.xml}");

    ${namespace}.user.extraGroups = [
      "audio"
      "input"
      "video"
    ];
  };
}
