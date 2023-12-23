{
  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (self) outputs;
    stateVersion = "23.11";
    libx = import ./lib {inherit inputs outputs stateVersion;};
  in {
    homeConfigurations = {
      "chnmy@hades" = libx.mkHome {
        hostname = "hades";
        username = "chnmy";
        desktop = "gnome";
      };
      "blurryface@trench" = libx.mkHome {
        hostname = "trench";
        username = "blurryface";
      };
    };
    nixosConfigurations = {
      hades = libx.mkHost {
        hostname = "hades";
        username = "chnmy";
        desktop = "gnome";
      };
      trench = libx.mkHost {
        hostname = "trench";
        username = "blurryface";
      };
    };
    formatter = libx.forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
  };

  inputs = {
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.home-manager.follows = "nixpkgs";
    auto-cpufreq.url = "github:adnanhodzic/auto-cpufreq";
    auto-cpufreq.inputs.nixpkgs.follows = "nixpkgs";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    firefox-nightly.url = "github:nix-community/flake-firefox-nightly";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    maych-in.url = "https://git.deku.moe/thunderbottom/website/archive/main.tar.gz";
    maych-in.inputs.nixpkgs.follows = "nixpkgs";
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
      "https://viperml.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "viperml.cachix.org-1:qZhKBMTfmcLL+OG6fj/hzsMEedgKvZVFRRAhq7j8Vh8="
    ];
  };
}
