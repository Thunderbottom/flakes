{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.snowflake.hardware.autofirma.enable =
    lib.mkEnableOption "AutoFirma digital signature support";

  config = lib.mkIf config.snowflake.hardware.autofirma.enable {
    programs.autofirma = {
      enable = true;
      firefoxIntegration.enable = true;
    };
    programs.configuradorfnmt = {
      enable = true;
      firefoxIntegration.enable = true;
    };
    programs.firefox = lib.mkIf config.snowflake.desktop.firefox.enable {
      policies.SecurityDevices = {
        "OpenSC PKCS#11" = "${pkgs.opensc}/lib/opensc-pkcs11.so";
        "DNIeRemote" = "${config.programs.dnieremote.finalPackage}/lib/libdnieremotepkcs11.so";
      };
    };
    services.pcscd.enable = true;
  };
}
