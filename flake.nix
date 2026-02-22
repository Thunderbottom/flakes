{

  outputs =
    { self, flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      imports = [
        ./hosts
        ./modules
        ./overlays
        ./packages
        ./templates
        inputs.treefmt-nix.flakeModule
      ];

      perSystem =
        { pkgs, system, ... }:
        {
          devShells = {
            default = pkgs.mkShell {
              packages = [
                pkgs.nh
                inputs.deploy-rs.packages.${system}.default
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

          treefmt = import "${self}/treefmt.nix";
          # formatter = (inputs.treefmt-nix.lib.evalModule pkgs "${self}/treefmt.nix").config.build.wrapper;
        };
    };

  inputs = {
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.home-manager.follows = "nixpkgs";

    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    firefox.url = "github:nix-community/flake-firefox-nightly";
    firefox.inputs.nixpkgs.follows = "nixpkgs";

    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    ghostty.url = "github:ghostty-org/ghostty";
    ghostty.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "github:hyprwm/Hyprland";

    lanzaboote.url = "github:nix-community/lanzaboote";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";

    # maych-in.url = "https://git.deku.moe/thunderbottom/website/archive/6e23df19298fb21dd3040419b520a00db32079dc.tar.gz";
    # maych-in.inputs.nixpkgs.follows = "nixpkgs";

    nil.url = "github:oxalica/nil";
    nil.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    nixos-mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
    nixos-mailserver.inputs.nixpkgs.follows = "nixpkgs";

    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";

    srvos.url = "github:nix-community/srvos";
    srvos.inputs.nixpkgs.follows = "nixpkgs";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    # toasters.url = "https://git.deku.moe/thunderbottom/toasters/archive/main.tar.gz";
    # toasters.inputs.nixpkgs.follows = "nixpkgs";

    wezterm.url = "github:wez/wezterm?dir=nix";
    wezterm.inputs.nixpkgs.follows = "nixpkgs";
    wezterm.inputs.rust-overlay.follows = "rust-overlay";

    # NOTE: enable this and switch ref for nightly builds
    # zed.url = "github:zed-industries/zed?ref=v0.190.6";
    # zed.inputs.nixpkgs.follows = "nixpkgs";
  };
}
