{
  config,
  lib,
  namespace,
  ...
}: {
  options.${namespace}.services.technitium = {
    enable = lib.mkEnableOption "Enable technitium dns server";
  };

  config = lib.mkIf config.${namespace}.services.technitium.enable {
    services.technitium-dns-server.enable = true;
    services.technitium-dns-server.openFirewall = true;
  };
}
