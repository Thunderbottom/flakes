{

  outputs =
    { flake-parts, nixpkgs, ... }@inputs:
    let
      inherit (nixpkgs) lib;

      # Every .nix file under ./modules is a flake-parts module, except for files
      # and directories prefixed with `_`, which are imported explicitly.
      modulesDir = ./modules;
      loadModules =
        dir:
        lib.filesystem.listFilesRecursive dir
        |> builtins.filter (
          path:
          lib.hasSuffix ".nix" path
          && !lib.any (lib.hasPrefix "_") (lib.path.subpath.components (lib.path.removePrefix dir path))
        );
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = loadModules modulesDir;
    };

  inputs = {
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    autofirma-nix.url = "github:nix-community/autofirma-nix/develop";
    autofirma-nix.inputs.nixpkgs.follows = "nixpkgs";

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

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "github:hyprwm/Hyprland";

    lanzaboote.url = "github:nix-community/lanzaboote";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";

    maych-in.url = "https://git.deku.moe/thunderbottom/website/archive/91534157f408d996f498b6bdf07bff77a0a82a45.tar.gz";
    maych-in.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    nixos-mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
    nixos-mailserver.inputs.nixpkgs.follows = "nixpkgs";

    srvos.url = "github:nix-community/srvos";
    srvos.inputs.nixpkgs.follows = "nixpkgs";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    toasters.url = "https://git.deku.moe/thunderbottom/toasters/archive/main.tar.gz";
    toasters.inputs.nixpkgs.follows = "nixpkgs";

    wezterm.url = "github:wez/wezterm?dir=nix";
    wezterm.inputs.nixpkgs.follows = "nixpkgs";

    # NOTE: enable this and switch ref for nightly builds
    # zed.url = "github:zed-industries/zed?ref=v0.190.6";
    # zed.inputs.nixpkgs.follows = "nixpkgs";
  };
}
