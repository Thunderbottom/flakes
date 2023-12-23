{
  config,
  desktop,
  hostname,
  inputs,
  lib,
  pkgs,
  stateVersion,
  username,
  ...
}: let
  inherit (pkgs.stdenv) isDarwin;
in {
  imports =
    [
      ./system
    ]
    ++ lib.optional (builtins.isPath (./. + "/system/users/${username}")) ./system/users/${username}
    ++ lib.optional (builtins.pathExists (./. + "/system/users/${username}/hosts/${hostname}.nix")) ./system/users/${username}/hosts/${hostname}.nix
    ++ lib.optional (desktop != null) ./system/desktop;

  home = {
    activation.report-changes = config.lib.dag.entryAnywhere ''
      ${pkgs.nvd}/bin/nvd diff $oldGenPath $newGenPath
    '';
    homeDirectory =
      if isDarwin
      then "/Users/${username}"
      else "/home/${username}";
    inherit stateVersion;
    inherit username;
  };

  # Workaround `home-manager news` bug with flakes
  # - https://github.com/nix-community/home-manager/issues/2033
  news.display = "silent";

  nixpkgs = {
    overlays = [
      inputs.emacs-overlay.overlay

      (_: prev: {
        inherit (inputs.agenix.packages.${prev.system}) agenix;
        inherit (inputs.firefox-nightly.packages.${prev.system}) firefox-nightly-bin;
        inherit (inputs.maych-in.packages.${prev.system}) maych-in;
        inherit (inputs.nil.packages.${prev.system}) nil;
        intel-vaapi-driver = prev.intel-vaapi-driver.override {enableHybridCodec = true;};
      })
    ];
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with flake
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    package = pkgs.nix;
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes" "auto-allocate-uids"];
      # Avoid unwanted garbage collection when using nix-direnv
      keep-outputs = true;
      keep-derivations = true;
      warn-dirty = false;
    };
  };
}
