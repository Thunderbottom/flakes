{
  flake.modules.nixos.cloudflare-dyndns =
    {
      config,
      lib,
      ...
    }:
    {
      config = {
        age.secrets.cloudflare-dyndns-token = {
          file = config.profile.secrets.services.cloudflare-ddns.api-token.file;
        };

        services.cloudflare-dyndns = {
          enable = true;
          apiTokenFile = config.age.secrets.cloudflare-dyndns-token.path;
          frequency = "*:0/5";
          ipv4 = true;
          ipv6 = false;
          deleteMissing = false;
        };
      };
    };
}
