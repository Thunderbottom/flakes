{
  flake.modules.nixos.technitium =
    {
      config,
      lib,
      ...
    }:
    {
      config = {

        services.technitium-dns-server.enable = true;
        services.technitium-dns-server.openFirewall = true;
      };
    };
}
