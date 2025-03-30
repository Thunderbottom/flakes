{
  config,
  inputs,
  lib,
  namespace,
  pkgs,
  ...
}:
{
  options.${namespace}.core.nix = {
    enable = lib.mkEnableOption "Enable core nix configuration";
  };

  config = lib.mkIf config.${namespace}.core.nix.enable {
    nix = {
      # Run garbage collector daily, and remove anything
      # older than 7 days.
      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 7d";
      };

      # Add each flake input as a registry to make nix3 commands
      # consistent with nix flakes.
      registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

      # Add inputs to system's legacy channels.
      nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

      # Use the latest, unstable version of nix.
      package = pkgs.nixVersions.latest;

      settings = {
        # Accept flake configuration without prompting.
        accept-flake-config = true;
        # Replace identical nix store files with hard links.
        auto-optimise-store = true;
        # Use cache from remote build machines if available.
        builders-use-substitutes = true;
        # Set git commit message for --commit-lock-file.
        commit-lockfile-summary = "chore: update flake.lock";
        experimental-features = [
          "auto-allocate-uids"
          "ca-derivations"
          "cgroups"
          "flakes"
          "nix-command"
          "recursive-nix"
        ];
        # Set local flake registry.
        flake-registry = "/etc/nix/registry.json";
        # Increase http connections (from 25 to 50) for binary cache.
        http-connections = 50;
        # Avoid unwanted garbage collection while using nix-direnv.
        keep-outputs = true;
        keep-derivations = true;
        max-jobs = "auto";
        # Use sandboxed build environments for builds on all systems.
        # Defaults to true on linux.
        sandbox = true;
        # Add `wheel` group to trusted users.
        trusted-users = [
          "root"
          "@wheel"
        ];
        # Disable warning for dirty git tree.
        warn-dirty = false;

        # Add cache substituters to allow fetching cached builds.
        trusted-substituters = [
          "https://nix-community.cachix.org"
          "https://hyprland.cachix.org"
          "https://helix.cachix.org"
          "https://wezterm.cachix.org"
          "https://ghostty.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
          "wezterm.cachix.org-1:kAbhjYUC9qvblTE+s7S+kl5XM1zVa4skO+E/1IDWdH0="
          "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns="
        ];
      };
    };

    system.switch = {
      enable = false;
      enableNg = true;
    };
  };
}
