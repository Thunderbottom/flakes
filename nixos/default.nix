{
  config,
  desktop,
  hostname,
  inputs,
  lib,
  modulesPath,
  pkgs,
  platform,
  stateVersion,
  username,
  ...
}: {
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
      ./machines/${hostname}
      ./system
      ./system/users/root
    ]
    ++ lib.optional (builtins.pathExists (./. + "/system/users/${username}")) ./system/users/${username}
    ++ lib.optional (desktop != null) ./system/desktop;

  console = {
    font = "Lat2-Terminus16";
    keyMap = lib.mkDefault "us";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  documentation = {
    enable = true;
    nixos.enable = false;
    man.enable = true;
    info.enable = false;
    doc.enable = false;
  };

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
    };
    hostPlatform = lib.mkDefault "${platform}";
  };
  # nix-helper configuration
  nix = {
    # run garbage collector daily
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
    # This will add each flake input as a registry
    # To make nix3 commands consistent with flake
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    # This will additionally add inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    optimise.automatic = true;
    package = pkgs.nixUnstable;
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes" "auto-allocate-uids"];
      # Avoid unwanted garbage collection when using nix-direnv
      keep-outputs = true;
      keep-derivations = true;
      # Add `wheel` group to trusted users
      trusted-users = ["root" "@wheel"];
      warn-dirty = false;
    };
  };

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Asia/Kolkata";

  virtualisation.docker = {
    enable = true;
    # Required for containers with `--restart=always`
    enableOnBoot = true;
  };

  system = {
    activationScripts.diff = {
      supportsDryActivation = true;
      text = ''
        ${pkgs.nvd}/bin/nvd --nix-bin-dir=${pkgs.nix}/bin diff /run/current-system "$systemConfig"
      '';
    };
    stateVersion = stateVersion;
  };
  zramSwap.enable = true;
}
