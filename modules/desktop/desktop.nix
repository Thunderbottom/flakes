{ nixos, ... }:
{
  flake.modules.nixos.desktop =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        nixos.bluetooth
        nixos.fonts
        nixos.pipewire
      ];

      config = {
        users.users.${config.profile.username}.extraGroups = [ "adbusers" ];

        programs.dconf.enable = true;

        services.geoclue2.enable = true;
        location.provider = "geoclue2";

        services.libinput.enable = true;

        services.printing.enable = true;
        services.printing.browsed.enable = false;

        services.xserver.enable = true;
        services.xserver.excludePackages = [ pkgs.xterm ];
        services.xserver.desktopManager.xterm.enable = false;

        xdg.portal.enable = true;
        xdg.portal.wlr.enable = true;
        xdg.portal.xdgOpenUsePortal = true;

        environment.systemPackages = [
          pkgs.android-tools
        ];

        environment.variables = {
          # Make Electron applications run in wayland.
          NIXOS_OZONE_WL = "1";
          GDK_BACKEND = "wayland";
          DIRENV_LOG_FORMAT = "";
          QT_AUTO_SCREEN_SCALE_FACTOR = "1";
          QT_QPA_PLATFORM = "wayland;xcb";
          XDG_SESSION_TYPE = "wayland";
          SDL_VIDEODRIVER = "wayland";
          CLUTTER_BACKEND = "wayland";
          FREETYPE_PROPERTIES = "truetype:interpreter-version=40";

          GST_PLUGIN_SYSTEM_PATH_1_0 = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" (
            with pkgs.gst_all_1;
            [
              gstreamer
              gst-plugins-base
              gst-plugins-good
              gst-plugins-bad
              gst-plugins-ugly
              gst-libav
            ]
          );
        };
      };
    };
}
