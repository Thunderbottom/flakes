{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      devShells = {
        default = pkgs.mkShell {
          packages = [
            pkgs.nh
            inputs.deploy-rs.packages.${pkgs.stdenv.hostPlatform.system}.default
          ];
        };

        sops = pkgs.mkShell {
          packages = [
            pkgs.sops
            pkgs.age
            pkgs.ssh-to-age
          ];
        };
      };

      treefmt = import ./_treefmt.nix;
    };
}
