{
  outputs =
    inputs:
    let
      lib = inputs.snowfall-lib.mkLib {
        inherit inputs;
        src = ./.;
        snowfall = {
          namespace = "snowflake";
          meta = {
            name = "nix-snowflake";
            title = "NixOS Flake configuration for snowflakes";
          };
        };
      };
      userdata = import ./data.nix;
    in
    lib.mkFlake {
      inherit inputs;
      src = ./.;

      systems.modules.nixos = with inputs; [
        agenix.nixosModules.age
        disko.nixosModules.disko
        srvos.nixosModules.common
        inputs.lanzaboote.nixosModules.lanzaboote
      ];

      systems.hosts.thonkpad.modules = [
        inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-12th-gen
      ];
      systems.hosts.thonkpad.specialArgs = {
        inherit userdata;
      };
      systems.hosts.zippyrus.modules = [ ];
      systems.hosts.zippyrus.specialArgs = {
        inherit userdata;
      };

      # TODO: setup atticd
      systems.hosts.bicboye.modules = [
        inputs.srvos.nixosModules.server
        inputs.srvos.nixosModules.mixins-systemd-boot
      ];
      systems.hosts.bicboye.specialArgs = {
        inherit userdata;
      };
      systems.hosts.smolboye.modules = [
        inputs.nixos-hardware.nixosModules.common-cpu-intel
        inputs.srvos.nixosModules.hardware-hetzner-cloud
      ];
      systems.hosts.smolboye.specialArgs = {
        inherit userdata;
      };

      homes.modules = with inputs; [
        nur.modules.homeManager.default
      ];

      overlays = [
        (_: prev: {
          inherit (inputs.maych-in.packages.${prev.system}) maych-in;
          inherit (inputs.nur.legacyPackages.${prev.system}.repos.rycee) firefox-addons;
        })
      ];

      channels-config.allowUnfree = true;

      outputs-builder = channels: {
        formatter = (inputs.treefmt-nix.lib.evalModule channels.nixpkgs ./treefmt.nix).config.build.wrapper;
      };

      deploy = lib.mkDeploy { inherit (inputs) self; };

      templates = {
        module.description = "Flake template for creating a new nix module";
        desktop.description = "Flake template for creating a new desktop configuration";
        server.description = "Flake template for creating a new server configuration";
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

    ghostty.url = "github:ghostty-org/ghostty";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # NOTE: enable this to make hyprland work
    # hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";

    lanzaboote.url = "github:nix-community/lanzaboote";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";

    maych-in.url = "https://git.deku.moe/thunderbottom/website/archive/main.tar.gz";
    maych-in.inputs.nixpkgs.follows = "nixpkgs";

    nil.url = "github:oxalica/nil";
    nil.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    nixos-mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
    nixos-mailserver.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/nur";
    nur.inputs.nixpkgs.follows = "nixpkgs";

    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";

    snowfall-lib.url = "github:snowfallorg/lib";
    snowfall-lib.inputs.nixpkgs.follows = "nixpkgs";

    srvos.url = "github:nix-community/srvos";
    srvos.inputs.nixpkgs.follows = "nixpkgs";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    wezterm.url = "github:wez/wezterm?dir=nix";
    wezterm.inputs.nixpkgs.follows = "nixpkgs";
    wezterm.inputs.rust-overlay.follows = "rust-overlay";
  };
}
