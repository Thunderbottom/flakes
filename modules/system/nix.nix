{
  flake.modules.nixos.nix =
    {
      config,
      inputs,
      lib,
      pkgs,
      ...
    }:
    {
      config = {
        nix = {
          gc = {
            automatic = true;
            dates = "daily";
            options = "--delete-older-than 7d";
          };

          registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

          nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

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
              "pipe-operators"
            ];
            # Set local flake registry.
            flake-registry = "/etc/nix/registry.json";
            # Increase http connections (from 25 to 50) for binary cache.
            http-connections = 50;
            # Avoid unwanted garbage collection while using nix-direnv.
            keep-outputs = true;
            keep-derivations = true;
            min-free = 5368709120;
            max-free = 10737418240;
            trusted-users = [
              "root"
              "@wheel"
            ];
            warn-dirty = false;

            substituters = [
              "https://nix-community.cachix.org"
              "https://hyprland.cachix.org"
              "https://wezterm.cachix.org"
            ]
            # The host serving the cache has no need to substitute from itself.
            ++ lib.optional (
              !config.services.harmonia.cache.enable
            ) "https://${config.profile.services.harmonia.domain}";
            trusted-public-keys = [
              "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
              "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
              "wezterm.cachix.org-1:kAbhjYUC9qvblTE+s7S+kl5XM1zVa4skO+E/1IDWdH0="
              "cache.deku.moe-1:kYj1dcytpPRDoh8EfjhnM/s/l1LUCaWZkfoWkBcFFJY="
            ];
          };
        };
      };
    };
}
