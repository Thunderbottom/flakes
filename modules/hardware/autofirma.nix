{
  flake.modules.nixos.autofirma =
    {
      config,
      inputs,
      pkgs,
      ...
    }:
    {
      imports = [ inputs.autofirma-nix.nixosModules.default ];

      config = {
        programs.autofirma = {
          enable = true;
          firefoxIntegration.enable = true;
        };
        programs.configuradorfnmt = {
          enable = true;
          firefoxIntegration.enable = true;
        };
        programs.firefox = {
          policies.SecurityDevices = {
            "OpenSC PKCS#11" = "${pkgs.opensc}/lib/opensc-pkcs11.so";
            "DNIeRemote" = "${config.programs.dnieremote.finalPackage}/lib/libdnieremotepkcs11.so";
          };
        };
        services.pcscd.enable = true;
      };
    };
}
