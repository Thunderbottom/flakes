{ nixos, ... }:
{
  flake.modules.nixos.navidrome =
    { config, ... }:
    let
      cfg = config.profile.services.navidrome;
    in
    {
      imports = [
        nixos.proxy
        nixos.fail2ban
      ];

      services.navidrome = {
        enable = true;
        group = "media";
        settings = {
          Address = "127.0.0.1";
          Port = cfg.port;
          MusicFolder = "/storage/media/music";
        };
      };

      proxy.navidrome = {
        inherit (cfg) domain;
        upstream = "http://localhost:${toString cfg.port}/";
        websockets = true;
      };

      fail2ban.navidrome = {
        failregex = ''msg="Unsuccessful login".*X-Real-Ip:\[<HOST>\]'';
      };
    };
}
