{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
{
  options.${namespace}.desktop.plymouth = {
    enable = lib.mkEnableOption "Enable Plymouth for graphical boot animation";
  };

  config = lib.mkIf config.${namespace}.desktop.plymouth.enable {
    boot = {
      plymouth = {
        enable = true;
        theme = "nixos-bgrt";
        themePackages = [ pkgs.nixos-bgrt-plymouth ];
      };

      consoleLogLevel = 0;
      initrd.verbose = false;
      kernelParams = [
        "quiet"
        "splash"
        "boot.shell_on_fail"
        "loglevel=3"
        "rd.systemd.show_status=false"
        "rd.udev.log_level=3"
        "udev.log_priority=3"
        "plymouth.use-simpledrm"
      ];
      loader.timeout = 0;
    };
  };
}
