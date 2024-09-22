{
  config,
  lib,
  pkgs,
  ...
}: {
  options.snowflake.desktop.kde = {
    enable = lib.mkEnableOption "Enable the KDE Plasma Desktop Environment";
  };

  config = lib.mkIf config.snowflake.desktop.kde.enable {
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
      konsole
      khelpcenter
      kate
      elisa
    ];

    # Disable fprint authentication for login.
    # SDDM does not work well with fingerprint authentication.
    security.pam.services.login.fprintAuth = false;

    xdg.portal.extraPortals = with pkgs; [
      xdg-desktop-portal-kde
    ];

    snowflake.user.extraGroups = [
      "audio"
      "input"
      "video"
    ];
  };
}
