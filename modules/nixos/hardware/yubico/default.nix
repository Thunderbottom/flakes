{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: {
  options.${namespace}.hardware.yubico.enable = lib.mkEnableOption "Enable yubico hardware support";

  config = lib.mkIf config.${namespace}.hardware.yubico.enable {
    # Enable FIDO authentication support.
    # ref: https://nixos.wiki/wiki/Yubikey
    security.pam = {
      u2f.enable = true;
      services = {
        login.u2fAuth = true;
        sudo.u2fAuth = true;
      };
    };
    services.udev.packages = [pkgs.yubikey-personalization];
  };
}
