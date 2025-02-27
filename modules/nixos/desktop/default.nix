{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: {
  options.${namespace}.desktop = {
    enable = lib.mkEnableOption "Enable core Desktop Environment configuration";
    fingerprint.enable = lib.mkEnableOption "Enable fingerprint support for Desktop Environments";
  };

  config = lib.mkIf config.${namespace}.desktop.enable {
    ${namespace} = {
      # Enable the fonts module.
      desktop.fonts.enable = true;
      # Enable the pipewire module.
      desktop.pipewire.enable = true;

      # Add user to networkmanager and adbusers group.
      # Works only when ${namespace}.user.enable is true.
      user.extraGroups = ["adbusers"];
    };

    # Enable ADB for Android devices.
    programs.adb.enable = true;
    programs.dconf.enable = true;
    # Start the ssh agent if enabled.
    programs.ssh.startAgent = config.${namespace}.core.sshd.enable;

    # Enable fingerprint authentication.
    # Requires fingerprint registered using `fprint-enroll` to work.
    services.fprintd.enable = config.${namespace}.desktop.fingerprint.enable;
    services.libinput.enable = true;

    services.xserver.enable = true;
    # Prevents xterm from being installed.
    # Prefer installing a custom terminal emulator instead.
    services.xserver.excludePackages = [pkgs.xterm];
    services.xserver.desktopManager.xterm.enable = false;

    # Add udev rules for ADB.
    services.udev.packages = [pkgs.android-udev-rules];

    # Enable XDG Portal.
    # Additional configuration will be done through individual
    # desktop environment configurations.
    xdg.portal.enable = true;
    # Additional configuration for XDG Portal.
    xdg.portal.wlr.enable = true;
    xdg.portal.xdgOpenUsePortal = true;

    # Add bibata cursors everywhere because it looks cool.
    environment.systemPackages = [pkgs.bibata-cursors];

    # Set environment variables for the system.
    environment.variables = {
      # Make Electron applications run in wayland.
      NIXOS_OZONE_WL = "1";
      # Disable G-Sync and VRR.
      __GL_GSYNC_ALLOWED = "0";
      __GL_VRR_ALLOWED = "0";
      GDK_BACKEND = "wayland";
      DIRENV_LOG_FORMAT = "";
      WLR_DRM_NO_ATOMIC = "1";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_QPA_PLATFORM = "wayland;xcb";
      WLR_BACKEND = "vulkan";
      WLR_RENDERER = "vulkan";
      XDG_SESSION_TYPE = "wayland";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
    };
  };
}
