{pkgs, ...}: {
  # Install a few enchancements for gnome
  environment.systemPackages = with pkgs; [
    gnome.gnome-tweaks
    gnomeExtensions.appindicator
    gnomeExtensions.blur-my-shell
    gnomeExtensions.just-perfection
    gnomeExtensions.vitals
    pinentry-gnome
  ];

  # Add udev rules for gnome-settings-daemon
  # to allow changes to the gnome shell
  services.udev.packages = with pkgs; [gnome.gnome-settings-daemon];

  # Remove some gnome bloatware that we don't require
  environment.gnome.excludePackages = with pkgs.gnome; [
    cheese
    eog
    epiphany
    evince
    geary
    seahorse
    simple-scan
    totem
    yelp

    gnome-calendar
    gnome-characters
    gnome-clocks
    gnome-contacts
    gnome-font-viewer
    gnome-logs
    gnome-maps
    gnome-music
    gnome-weather
    pkgs.gnome-console
    pkgs.gnome-tour
  ];

  # Enable the GNOME Desktop Environment.
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    excludePackages = with pkgs; [xterm];
    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
  };
}
