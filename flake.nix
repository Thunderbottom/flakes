{
  outputs = {
    self,
    home-manager,
    nixos-hardware,
    nixpkgs,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    nixosSystem = import ./lib/nixosSystem.nix;

    # Add package overlays and enable unfree
    pkgs = import nixpkgs {
      inherit system;
      config = {allowUnfree = true;};
      overlays = [
        inputs.emacs-overlay.overlay
        (_: prev: {
          inherit (inputs.devenv.packages.${prev.system}) devenv;
          inherit (inputs.firefox-nightly.packages.${prev.system}) firefox-nightly-bin;
          inherit (inputs.nil.packages.${prev.system}) nil;
          intel-vaapi-driver = prev.intel-vaapi-driver.override {enableHybridCodec = true;};
        })
      ];
    };

    commons = [
      inputs.agenix.nixosModules.default
      inputs.nh.nixosModules.default
      inputs.nixvim.nixosModules.nixvim
    ];

    # Laptop, X1 Carbon 9th Gen.
    hades = {
      nixos-modules =
        [
          ./machines/hades
          nixos-hardware.nixosModules.lenovo-thinkpad-x1-9th-gen
        ]
        ++ commons;
      home-module = import ./home/desktop;
      specialArgs =
        {
          username = "chnmy";
          passwdHash = "$y$j9T$G75cisWVMV27C2TLIqk0P/$GsICzokHJs.FQ2Yr2rLga9iawMrY3g1SAwe8wYZNY6/";
          sshKeys = [];
        }
        // inputs;
    };

    # Server, AMD A8 APU.
    trench = {
      nixos-modules =
        [
          ./machines/trench
        ]
        ++ commons;
      home-module = import ./home/base;
      specialArgs =
        {
          username = "blurryface";
          passwdHash = "$y$j9T$ab7R9O2uUPI.ctGSVWgMg0$eA2Eh2lP7XxJpslkxSIy8AJQvpkvwJKwSqK9B5TOXS3";
          sshKeys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJQWA+bAwpm9ca5IhC6q2BsxeQH4WAiKyaht48b7/xkN cc@predator"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKJnFvU6nBXEuZF08zRLFfPpxYjV3o0UayX0zTPbDb7C cc@eden"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG3PeMbehJBkmv8Ee7xJimTzXoSdmAnxhBatHSdS+saM chnmy@bastion"
          ];
        }
        // inputs;
    };
  in {
    nixosConfigurations = let
      base = {
        inherit home-manager nixpkgs pkgs system;
      };
    in {
      hades = nixosSystem (hades // base);
      trench = nixosSystem (trench // base);
    };

    formatter = {
      "${system}" = nixpkgs.legacyPackages.${system}.alejandra;
    };
  };

  inputs = {
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.home-manager.follows = "nixpkgs";
    devenv.url = "github:cachix/devenv";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    firefox-nightly.url = "github:nix-community/flake-firefox-nightly";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nh.url = "github:viperML/nh";
    nil.url = "github:oxalica/nil";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixvim.url = "github:nix-community/nixvim";
  };

  nixConfig = {
    max-jobs = "auto";

    # Add extra substituters for caching.
    # This prevents building from source and instead fetches from
    # the specified cache.
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://devenv.cachix.org"
      "https://viperml.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "viperml.cachix.org-1:qZhKBMTfmcLL+OG6fj/hzsMEedgKvZVFRRAhq7j8Vh8="
    ];
  };
}
