{
  flake.modules.nixos.gnupg =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = {
        services.pcscd.enable = true;

        programs.gnupg.agent = {
          enable = true;
        };

        environment.systemPackages = [ pkgs.gnupg ];
      };
    };
}
