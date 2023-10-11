{
  pkgs,
  nixpkgs,
  home-manager,
  system,
  specialArgs,
  nixos-modules,
  home-module,
}: let
  username = specialArgs.username;
in
  nixpkgs.lib.nixosSystem {
    inherit pkgs system specialArgs;
    modules =
      nixos-modules
      ++ [
        {
          # use flake's nixpkgs for `nix run nixpkgs#nixpkgs`
          # and `nix repl '<nixpkgs>'`
          nix.registry.nixpkgs.flake = nixpkgs;
          environment.etc."nix/inputs/nixpkgs".source = "${nixpkgs}";
          nix.nixPath = ["/etc/nix/inputs"];
        }

        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = specialArgs;
            users."${username}" = home-module;
          };
        }
      ];
  }
