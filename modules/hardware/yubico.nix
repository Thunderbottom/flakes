{
  flake.modules.nixos.yubico =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = {
        # ref: https://nixos.wiki/wiki/Yubikey
        security.pam = {
          u2f.enable = true;
          services = {
            login.u2fAuth = true;
            sudo.u2fAuth = true;
          };
        };
        services.udev.packages = [ pkgs.yubikey-personalization ];
      };
    };
}
