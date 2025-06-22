{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.snowflake.core.lanzaboote.enable = lib.mkEnableOption "Enable secure boot configuration";

  config = lib.mkIf config.snowflake.core.lanzaboote.enable {
    environment.systemPackages = [ pkgs.sbctl ];

    boot.loader.systemd-boot.enable = lib.mkForce false;
    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
  };
}
