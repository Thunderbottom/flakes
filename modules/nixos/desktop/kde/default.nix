{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: {
  options.${namespace}.desktop.kde = {
    enable = lib.mkEnableOption "Enable the KDE Plasma Desktop Environment";
  };

  config = lib.mkIf config.${namespace}.desktop.kde.enable {
    services = {
      displayManager.sddm = {
        enable = true;
        wayland.enable = true;
        wayland.compositor = "kwin";
      };
      desktopManager.plasma6.enable = true;
    };

    # Remove bloatware that we do not require.
    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      elisa
      kate
      khelpcenter
      konsole
      plasma-browser-integration
    ];

    # Disable fprint authentication for login.
    # SDDM does not work well with fingerprint authentication.
    security.pam.services.login.fprintAuth = false;

    xdg.portal.extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde
      xdg-desktop-portal-gtk
    ];

    ${namespace}.user.extraGroups = [
      "audio"
      "input"
      "video"
    ];
  };
}
