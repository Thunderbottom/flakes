{
  outputs = inputs: let
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
        chaotic.nixosModules.default
        disko.nixosModules.disko
        srvos.nixosModules.common
        srvos.nixosModules.mixins-systemd-boot
      ];

      systems.hosts.thonkpad.modules = [
        inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-12th-gen
        inputs.lanzaboote.nixosModules.lanzaboote
      ];
      systems.hosts.thonkpad.specialArgs = {
        inherit userdata;
      };
      # TODO: setup atticd
      systems.hosts.bicboye.modules = [inputs.srvos.nixosModules.server];
      systems.hosts.bicboye.specialArgs = {
        inherit userdata;
      };
      systems.hosts.smolboye.modules = [inputs.srvos.nixosModules.server];

      homes.modules = with inputs; [
        nur.hmModules.nur
      ];

      overlays = [(_: prev: {inherit (inputs.maych-in.packages.${prev.system}) maych-in;})];

      channels-config.allowUnfree = true;

      outputs-builder = channels: {
        formatter = channels.nixpkgs.writeShellApplication {
          name = "format";
          runtimeInputs = with channels.nixpkgs; [
            nixfmt-rfc-style
            deadnix
            shfmt
            statix
          ];
          text = ''
            set -euo pipefail
            shfmt --write --simplify --language-dialect bash --indent 2 --case-indent --space-redirects .;
            deadnix --edit
            statix check . || statix fix .
            nixfmt .
          '';
        };
      };

      deploy = lib.mkDeploy {inherit (inputs) self;};
    };

  inputs = {
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.home-manager.follows = "nixpkgs";

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    firefox.url = "github:nix-community/flake-firefox-nightly";
    firefox.inputs.nixpkgs.follows = "nixpkgs";

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
    nixpkgs-immich.url = "github:nixos/nixpkgs/d026e3fa1ad0d78d9072d9afdeae515d2d68acae";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    nur.url = "github:nix-community/nur";

    snowfall-lib.url = "github:snowfallorg/lib";
    snowfall-lib.inputs.nixpkgs.follows = "nixpkgs";

    srvos.url = "github:nix-community/srvos";
    srvos.inputs.nixpkgs.follows = "nixpkgs";

    wezterm.url = "github:wez/wezterm?dir=nix";
    wezterm.inputs.nixpkgs.follows = "nixpkgs";
  };
}
