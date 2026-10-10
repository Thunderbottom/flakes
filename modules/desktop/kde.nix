{ nixos, ... }:
{
  flake.modules.nixos.kde =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [ nixos.desktop ];

      config = {
        services = {
          displayManager.sddm = {
            enable = true;
            wayland.enable = true;
            wayland.compositor = "kwin";
          };
          desktopManager.plasma6.enable = true;
        };

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

        users.users.${config.profile.username}.extraGroups = [
          "audio"
          "input"
          "video"
        ];
      };
    };
}
