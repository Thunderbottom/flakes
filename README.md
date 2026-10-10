<h1 align="center">NixOS Snowflake</h1>
<p align="center">
    <a href="https://builtwithnix.org">
        <img alt="Built with Nix" src="https://builtwithnix.org/badge.svg">
    </a>
</p>

---

This repository contains my NixOS configurations, carefully put together over a long time and in often places inspired by other similar setups. It follows the [dendritic pattern](https://github.com/mightyiam/dendritic), is flake-based and fully reproducible. Feel free to explore and use any part that inspires you.

## Highlights

- Modular flake setup based on [flake-parts](https://flake.parts/), with no other helper libraries
- Every component lives in a single file, with its NixOS and Home Manager parts side by side
- Modules pull in whatever they depend on, so a host only lists what it is
- Personal preferences in one place, which any host can override
- Secret management based on [Agenix](https://github.com/ryantm/agenix)
- Encrypted BTRFS setup

## Structure

```
.
├── flake.nix        # inputs, and the loader for everything under modules/
├── modules
│   ├── hosts        # one directory per machine
│   ├── profile      # my preferences: identity, domain, service domains and ports
│   ├── system       # base, laptop and server profiles, users, nix, ssh, networking
│   ├── hardware     # cpu, gpu, bluetooth, yubikey, disk layouts
│   ├── desktop      # desktop environments, apps, gaming
│   ├── programs     # shell and development tools
│   ├── services     # self-hosted services (arr, monitoring, ...)
│   ├── users        # what each user gets in Home Manager
│   ├── overlays     # one file per overlay
│   └── nix          # flake plumbing: hosts, deploy, devshell, formatter, templates
├── secrets          # agenix secrets
└── templates        # starting points for a new module, desktop or server
```

Every `.nix` file under `modules/` is loaded automatically, except files and directories starting with an `_`, which are imported by hand. A file describes one component and holds all of its parts, for example `flake.modules.nixos.fish` and `flake.modules.homeManager.fish` next to each other. Run `git add` on new files, flakes only see tracked ones.

### Preferences

Everything personal lives in [`modules/profile/preferences.nix`](modules/profile/preferences.nix) and is read as `config.profile` from both NixOS and Home Manager modules: name, email, domain, the domain and port of each service, and the paths of all secrets. These are only defaults. A host can override any of them with `profile.<name> = ...`, for example `profile.fullName` or `profile.services.forgejo.port`, and the change reaches Home Manager as well. Servers log in as `server` this way.

Service domains and ports must be unique, which is checked when a host is evaluated.

### Modules

A module imports the modules it needs, so enabling something is just importing it. `nixos.gnome` brings the desktop along, `nixos.forgejo` brings nginx, postgres, fail2ban and the backup registry, and `nixos.laptop` brings the base. Importing the same module from several places is fine.

Two small options exist for modules to contribute to: `proxy.<name>` turns a service into an nginx vhost with TLS, and `backups.<name>` adds paths to the restic backups. Everything else is the regular NixOS and Home Manager options.

### Adding a host

Create `modules/hosts/<name>/default.nix`:

```nix
{ nixos, ... }:
{
  configurations.nixos.<name>.module.imports = [
    nixos.laptop
    nixos.gnome
    nixos.docker
    ./_hardware.nix
  ];
}
```

Settings that only apply to this machine go in the same file. The password hashes are expected in `secrets/machines/<name>/`.

## Systems

- `zippyrus`: Primary workstation on ASUS Zephyrus GA403UI - AMD Ryzen 9 8945HS, 32GB RAM, Nvidia 4070
- `bicboye`: A custom-built Homelab running Intel Core i5 12600K, 32GB RAM, 16TB storage
- `smolboye`: Hetzner Cloud VPS Running a dual-core Intel Xeon, 4GB RAM

## Secrets

For all deployment secrets, I am using `agenix`. All secrets are stored in the `secrets/` directory and are encrypted with host SSH keys.

### Adding secrets

To add new deployment secrets:

- Create the secret under `secrets/` and add an entry for it to `secrets.nix`
- Create/Edit the secret with agenix. This command needs to be run in the same directory as `secrets.nix`. You do not require agenix to be installed, and instead can use `nix run`, for example:

```shell
$ nix run github:ryantm/agenix#agenix -- -e services/service-name/password.age
```

- That is all. Every `.age` file under `secrets/` shows up as `config.profile.secrets.<path>.file`, so the example above becomes `config.profile.secrets.services.service-name.password.file`.

## Usage

### NixOS Installation

This repository does not walk you through the entire installation process, but instead lists down steps to get an encrypted BTRFS partition setup for NixOS, mostly for future reference. So prepare a NixOS installation disk your preferred way, either by downloading the ISO, or using scripts like [`nixos-anywhere`](https://github.com/nix-community/nixos-anywhere) to bootstrap your system.

You may setup NixOS through either the traditional way, by manual partitioning, or through [`disko`](https://github.com/nix-community/disko).

#### Traditional Partitioning

##### Disk Setup

Wipe the partition table with `wipefs -a /dev/nvme0n1`. Edit the partition table to create two partitions:

- `/dev/nvme0n1p1` - 512MiB EFI partition. This won't be encrypted.
- `/dev/nvmen01p2` - root partition, will use LUKS+BTRFS for root.

An encrypted swap partition can optionally be set up using BTRFS later.

##### BTRFS Setup

All commands prefixed with `#` are expected to be run as the `root` user. Make sure to enter a strong encryption password during `luksFormat` (and then remember it!).

```shell
# cryptsetup luksFormat --type=luks2 /dev/nvme0n1p2
# cryptsetup open /dev/nvme0n1p2 cryptroot
```

- Format the EFI and the root partition:

```shell
# mkfs.fat -F32 /dev/nvme0n1p1
# mkfs.btrfs /dev/mapper/cryptroot
```

- Create BTRFS subvolumes:

```shell
# mount /dev/mapper/cryptroot /mnt
# btrfs subvolume create /mnt/@
# btrfs subvolume create /mnt/@home
# btrfs subvolume create /mnt/@snapshots
# btrfs subvolume create /mnt/@log
# btrfs subvolume create /mnt/@cache
# btrfs subvolume create /mnt/@nix-config
# btrfs subvolume create /mnt/@nix-store
```

- Create directories for the subvolumes:

```shell
# mkdir /mnt/@/home
# mkdir /mnt/@/.snapshots
# mkdir /mnt/@/boot
# mkdir /mnt/@/nix
# mkdir -p /mnt/@/var/log
# mkdir -p /mnt/@/var/cache
# mkdir -p /mnt/@/etc/nixos
# mkdir -p /mnt/@/nix

# umount -R /mnt
```

- Mount all the file systems

```shell
# mount -o ssd,noatime,compress=zstd,space_cache=v2,autodefrag,subvol=@ /dev/mapper/cryptroot /mnt
# mount -o ssd,noatime,compress=zstd,space_cache=v2,autodefrag,subvol=@home,nodev /dev/mapper/cryptroot /mnt/home
# mount -o ssd,noatime,compress=zstd,space_cache=v2,autodefrag,subvol=@snapshots,nodev,nosuid,noexec /dev/mapper/cryptroot /mnt/.snapshots
# mount -o ssd,noatime,compress=zstd,space_cache=v2,autodefrag,subvol=@log,nodev,nosuid,noexec /dev/mapper/cryptroot /mnt/var/log
# mount -o ssd,noatime,compress=zstd,space_cache=v2,autodefrag,subvol=@cache,nodev,nosuid,noexec /dev/mapper/cryptroot /mnt/var/cache
# mount -o ssd,noatime,compress=zstd,space_cache=v2,autodefrag,subvol=@nix-config,nodev /dev/mapper/cryptroot /mnt/etc/nixos
# mount -o ssd,noatime,compress=zstd,space_cache=v2,autodefrag,subvol=@nix-store,nodev /dev/mapper/cryptroot /mnt/nix
# mount /dev/nvme0n1p1 /mnt/boot
```

#### Alternative Partitioning using Disko

Disko is a helper tool that lets you declaratively specify disk partitions for your system. This can be used as a replacement for the `fileSystems.*` option in NixOS. Check out the [`disko`](https://github.com/nix-community/disko) repository to set it up in flakes, or refer `flake.nix` for the setup.

##### Disko Configuration

A sample disko configuration for a VPS set up using `nixos-anywhere`:

```nix
# hosts/smolboye/disk-config.nix
{
  disko.devices = {
    disk = {
      sda = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              priority = 1;
              name = "ESP";
              start = "1M";
              end = "128M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = ["-f"];
                subvolumes = {
                  "/root" = {
                    mountpoint = "/";
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                  "/home" = {
                    mountpoint = "/home";
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                  "/swap" = {
                    mountpoint = "/.swapvol";
                    mountOptions = ["nodatacow" "noatime"];
                    swap.swapfile.size = "20M";
                  };
                  "/log" = {
                    mountpoint = "/var/log";
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
```

To partition the disks in live USB:

```shell
# nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./hosts/smolboye/disk-config.nix
```

Alternatively, running `nixos-install` should take care of the partitioning for you.

#### Installation

- Clone the git repository

```shell
# git clone https://git.deku.moe/thunderbottom/flakes.git /mnt/etc/nixos
```

- Get the UUID for the disks and edit `hardware.nix` to match the `blkid` output. This step can be skipped if you are using `disko`:

```shell
# blkid

/dev/nvme0n1p1: UUID="7FBB-9E80" BLOCK_SIZE="512" TYPE="vfat" PARTUUID="b4e5f895-cd2d-4cc9-9878-03dc8fca178c"
/dev/nvme0n1p2: UUID="9de352ea-128f-4d56-a720-36d81dfd9b92" TYPE="crypto_LUKS" PARTUUID="95574dc5-5f5d-465d-b01c-f76918f7a125"
/dev/mapper/cryptroot: UUID="870fde90-a91a-4554-8b1c-d5702c789f4d" UUID_SUB="ccc90835-8b61-4d8e-8293-e1323a02fb3b" BLOCK_SIZE="4096" TYPE="btrfs"
```

If you are not using `disko` for partition setup, make sure to set the following values in `hardware.nix`:

- `luks.devices."cryptroot".device` to `/dev/nvme0n1p2` output, in this case: `/dev/disk/by-uuid/9de352ea-128f-4d56-a720-36d81dfd9b92`
- All the values in `fileSystems.*`, except `/boot` to `/dev/mapper/cryptroot` output, `/dev/disk/by-uuid/870fde90-a91a-4554-8b1c-d5702c789f4d`
- `fileSystems."/boot"` to `/dev/nvme0n1p1` output, `/dev/disk/by-uuid/7FBB-9E80`

Check any of the `hardware.nix` files in the repository for more details.

- Install NixOS with `nixos-install` and then `reboot`.

### Deployments

#### `deploy-rs`

To deploy all hosts using `deploy-rs`:

```shell
$ deploy
```

To deploy a specific host:

```shell
$ deploy .#hostname
```

#### Traditional Nix Deployment

To deploy the traditional way using `nix`:

```shell
# nixos-rebuild switch --flake '.#hostname'
```

It is also possible to rebuild and deploy NixOS to a remote host. This can be used in cases where the remote host is incapable of building packages, or while running a VPS. To run remote deployments:

```shell
# nixos-rebuild switch --flake '.#hostname' --target-host user@ip --use-remote-sudo
```
