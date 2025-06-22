{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.snowflake.hardware.yubico.enable = lib.mkEnableOption "Enable yubico hardware support";

  config = lib.mkIf config.snowflake.hardware.yubico.enable {
    # Enable FIDO authentication support.
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
}
