{
  flake.modules.nixos.lanzaboote =
    {
      inputs,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

      config = {
        environment.systemPackages = [ pkgs.sbctl ];

        boot.loader.systemd-boot.enable = lib.mkForce false;
        boot.lanzaboote = {
          enable = true;
          pkiBundle = "/var/lib/sbctl";
        };
      };
    };
}
