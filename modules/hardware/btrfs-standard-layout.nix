{
  flake.modules.nixos.btrfs-standard-layout =
    { config, lib, ... }:
    # Standard btrfs layout module for laptop systems with LUKS encryption.
    #
    # This module provides a reusable btrfs filesystem configuration with:
    # - LUKS full-disk encryption
    # - Standard subvolume layout (@, @home, @snapshots, @log, @cache, @nix-config, @nix-store)
    # - Optimized mount options for SSD performance
    # - Consistent configuration across all laptop hosts
    #
    # Usage:
    #   profile.disk = {
    #     rootUUID = "...";  # UUID of decrypted btrfs device
    #     luksUUID = "...";  # UUID of LUKS encrypted device
    #     bootUUID = "...";  # UUID of EFI boot partition
    #   };
    let
      cfg = config.profile.disk;

      mkBtrfsMount =
        device: subvol: mountpoint: extraOpts:
        {
          inherit device;
          fsType = "btrfs";
          options = [
            "compress-force=zstd:3" # Level 3: good compression/performance balance
            "noatime" # Don't update access times
            "nodiratime" # Don't update directory access times
            "ssd" # SSD optimizations
            "space_cache=v2" # Free space cache v2
            "commit=120" # Commit interval: 120 seconds
            "discard=async" # Async TRIM for SSD
            "subvol=${subvol}"
          ]
          ++ extraOpts;
        }
        // lib.optionalAttrs (mountpoint == "/") {
          neededForBoot = true;
        };
    in
    {
      config = {
        # LUKS setup
        boot.initrd.luks.devices."cryptroot" = {
          device = "/dev/disk/by-uuid/${cfg.luksUUID}";
          bypassWorkqueues = true;
        };

        # Standard btrfs subvolume layout
        fileSystems = {
          "/" = mkBtrfsMount "/dev/disk/by-uuid/${cfg.rootUUID}" "@" "/" [ ];
          "/home" = mkBtrfsMount "/dev/disk/by-uuid/${cfg.rootUUID}" "@home" "/home" [ ];
          "/.snapshots" = mkBtrfsMount "/dev/disk/by-uuid/${cfg.rootUUID}" "@snapshots" "/.snapshots" [ ];
          "/var/log" = mkBtrfsMount "/dev/disk/by-uuid/${cfg.rootUUID}" "@log" "/var/log" [ ];
          "/var/cache" = mkBtrfsMount "/dev/disk/by-uuid/${cfg.rootUUID}" "@cache" "/var/cache" [ ];
          "/etc/nixos" = mkBtrfsMount "/dev/disk/by-uuid/${cfg.rootUUID}" "@nix-config" "/etc/nixos" [ ];
          "/nix" = mkBtrfsMount "/dev/disk/by-uuid/${cfg.rootUUID}" "@nix-store" "/nix" [ ];

          "/boot" = {
            device = "/dev/disk/by-uuid/${cfg.bootUUID}";
            fsType = "vfat";
            options = [
              "fmask=0022"
              "dmask=0022"
            ];
          };
        };

        swapDevices = [ ];
      };
    };
}
