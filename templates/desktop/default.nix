# Copy this directory to `modules/hosts/<hostname>/` and rename `desktop`
# below to the machine's hostname. New files are picked up automatically
# (run `git add` first). `_hardware.nix` is imported explicitly.
{ config, ... }:
let
  inherit (config.flake.modules) nixos;
in
{
  configurations.nixos.desktop.module = _: {
    imports = [
      nixos.laptop

      nixos.gnome
      nixos.docker
      nixos.steam
      nixos.proton
      nixos.yubico

      # Secure boot support.
      # NOTE: Requires setting up lanzaboote, read the link below for help.
      # ref: https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md
      # nixos.lanzaboote

      # GPU support.
      # NOTE: nvidia requires the bus IDs to be set below.
      nixos.intel-graphics
      # nixos.amd-graphics
      # nixos.nvidia-graphics

      ./_hardware.nix
    ];

    # NOTE: Since the system runs on nixos-unstable, this should be
    # set to the latest version as of the installation time.
    system.stateVersion = "25.05";

    # Add extra packages to the system
    environment.systemPackages = [ ];

    # Disk layout of the standard btrfs/LUKS layout (see `nixos.btrfs-standard-layout`).
    # profile.disk = {
    #   rootUUID = "...";
    #   luksUUID = "...";
    #   bootUUID = "...";
    # };

    # NOTE: the user password hashes are read from
    # `secrets/machines/<hostname>/{password,root-password}.age`, which need
    # entries in `secrets/secrets.nix`. They are created with agenix, check
    # the readme for more information.
  };
}
