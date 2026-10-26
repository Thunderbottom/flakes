{
  flake.modules.nixos.plymouth =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = {
        boot = {
          plymouth = {
            enable = true;
            theme = "nixos-bgrt";
            themePackages = [ pkgs.nixos-bgrt-plymouth ];
          };

          consoleLogLevel = 0;
          kernelParams = [
            "quiet"
            "splash"
          ];
          loader.timeout = 0;
        };
      };
    };
}
