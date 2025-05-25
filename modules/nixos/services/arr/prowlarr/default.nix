{
  config,
  lib,
  namespace,
  ...
}:
{
  options.${namespace}.services.prowlarr = {
    enable = lib.mkEnableOption "Enable prowlarr deployment configuration";
  };

  config = lib.mkIf config.${namespace}.services.prowlarr.enable {
    services.prowlarr.enable = true;
    services.prowlarr.openFirewall = true;
  };
}
