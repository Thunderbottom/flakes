{
  config,
  lib,
  namespace,
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
        theme = "bgrt";
      };

      consoleLogLevel = 0;
      initrd.verbose = false;
      kernelParams = [
        "quiet"
        "splash"
        "boot.shell_on_fail"
      ];
      loader.timeout = 0;
    };
  };
}
