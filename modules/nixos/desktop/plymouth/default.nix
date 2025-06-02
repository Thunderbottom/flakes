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
      ];
      loader.timeout = 0;
    };
  };
}
