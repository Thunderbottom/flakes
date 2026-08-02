# NixOS Module Options


## [`options.snowflake.bootloader`](modules/nixos/core/default.nix#L24)

Bootloader to use, can be either `systemd-boot` or `grub`

**Type:** `one of "systemd-boot", "grub"`

**Default:** `"systemd-boot"`

## [`options.snowflake.core.docker.enable`](modules/nixos/core/docker/default.nix#L8)

Whether to enable Enable core docker configuration.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.core.docker.enableOnBoot`](modules/nixos/core/docker/default.nix#L9)

Whether to enable Enable docker on boot.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.core.docker.storageDriver`](modules/nixos/core/docker/default.nix#L10)

Storage driver backend to use for docker

**Type:** `null or string`

**Default:** `null`

## [`options.snowflake.core.fish.enable`](modules/nixos/core/fish/default.nix#L8)

Whether to enable Enable core fish configuration.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.core.gnupg.enable`](modules/nixos/core/gnupg/default.nix#L8)

Whether to enable Enable core gnupg configuration.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.core.lanzaboote.enable`](modules/nixos/core/lanzaboote/default.nix#L8)

Whether to enable Enable secure boot configuration.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.core.nix.enable`](modules/nixos/core/nix/default.nix#L10)

Whether to enable Enable core nix configuration.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.core.security.enable`](modules/nixos/core/security/default.nix#L8)

Whether to enable Enable core security configuration.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.core.security.sysctl.enable`](modules/nixos/core/security/default.nix#L9)

Whether to enable Enable sysctl security configuration.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.core.sshd.enable`](modules/nixos/core/sshd/default.nix#L8)

Whether to enable Enable core sshd configuration.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.desktop.enable`](modules/nixos/desktop/default.nix#L9)

Whether to enable Enable core Desktop Environment configuration.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.desktop.extraPackages`](modules/nixos/desktop/default.nix#L12)

Additional packages to install for the desktop environment

**Type:** `list of package`

**Default:** `[ ]`

## [`options.snowflake.desktop.fingerprint.enable`](modules/nixos/desktop/default.nix#L10)

Whether to enable Enable fingerprint support for Desktop Environments.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.desktop.firefox.enable`](modules/home/desktop/firefox/default.nix#L9)

Whether to enable Enable firefox home configuration.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.desktop.fonts.enable`](modules/nixos/desktop/fonts/default.nix#L9)

Whether to enable Enable desktop font configuration.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.desktop.fonts.enableDefaultFonts`](modules/nixos/desktop/fonts/default.nix#L11)

Enable the default comprehensive font collection

**Type:** `boolean`

**Default:** `true`

## [`options.snowflake.desktop.fonts.extraFonts`](modules/nixos/desktop/fonts/default.nix#L17)

Additional fonts to install

**Type:** `list of package`

**Default:** `[ ]`

## [`options.snowflake.desktop.ghostty.enable`](modules/home/desktop/ghostty/default.nix#L9)

Whether to enable Enable ghostty home configuration.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.desktop.gnome-dconf.enable`](modules/home/desktop/gnome/default.nix#L10)

Whether to enable Enable gnome dconf home configuration.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.desktop.gnome.enable`](modules/nixos/desktop/gnome/default.nix#L9)

Whether to enable Enable the Gnome Desktop Environment.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.desktop.gnome.monitors.xml`](modules/nixos/desktop/gnome/default.nix#L10)

The monitors.xml configuration to use for gdm

**Type:** `string`

**Default:** `""`

## [`options.snowflake.desktop.hypridle.enable`](modules/home/desktop/hyprland/hypridle.nix#L7)

Whether to enable Enable hypridle home configuration.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## `options.snowflake.desktop.hyprland.enable`

**Declared in:**
- [`modules/home/desktop/hyprland/hyprland.nix`](modules/home/desktop/hyprland/hyprland.nix#L7)
- [`modules/nixos/desktop/hyprland/default.nix`](modules/nixos/desktop/hyprland/default.nix#L10)

Whether to enable Enable hyprland home configuration.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.desktop.hyprland.extraPackages`](modules/nixos/desktop/hyprland/default.nix#L12)

Additional packages to install for Hyprland

**Type:** `list of package`

**Default:** `[ ]`

## [`options.snowflake.desktop.hyprlock.enable`](modules/home/desktop/hyprland/hyprlock.nix#L7)

Whether to enable Enable hyprlock home configuration.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.desktop.hyprpaper.enable`](modules/home/desktop/hyprland/hyprpaper.nix#L8)

Whether to enable Enable hyprpaper home configuration.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.desktop.kde.enable`](modules/nixos/desktop/kde/default.nix#L9)

Whether to enable Enable the KDE Plasma Desktop Environment.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.desktop.pipewire.enable`](modules/nixos/desktop/pipewire/default.nix#L9)

Whether to enable Enable pipewire configuration.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.desktop.pipewire.enableLowLatency`](modules/nixos/desktop/pipewire/default.nix#L10)

Whether to enable Enable low-latency audio (might cause crackling).

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.desktop.plymouth.enable`](modules/nixos/desktop/plymouth/default.nix#L9)

Whether to enable Enable Plymouth for graphical boot animation.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.desktop.waybar.enable`](modules/home/desktop/waybar/default.nix#L7)

Whether to enable Enable waybar home configuration.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.desktop.wezterm.enable`](modules/home/desktop/wezterm/default.nix#L9)

Whether to enable Enable wezterm home configuration.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.development.git.enable`](modules/home/development/git/default.nix#L21)

Whether to enable Enable development git configuration.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.development.git.user.email`](modules/home/development/git/default.nix#L27)

Email for the work git profile

**Type:** `string`

## [`options.snowflake.development.git.user.name`](modules/home/development/git/default.nix#L23)

Real name for the work git profile

**Type:** `string`

## [`options.snowflake.development.git.user.signingKey`](modules/home/development/git/default.nix#L31)

Public GPG Key for the work git profile

**Type:** `string`

## [`options.snowflake.development.git.work.email`](modules/home/development/git/default.nix#L46)

Email for the work git profile

**Type:** `string`

## [`options.snowflake.development.git.work.enable`](modules/home/development/git/default.nix#L36)

Whether to enable Enable work git configuration.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.development.git.work.extraConfig`](modules/home/development/git/default.nix#L41)

Additional configuration for work git.

**Type:** `strings concatenated with "\n" or gitIniType`

**Default:** `{ }`

## [`options.snowflake.development.git.work.path`](modules/home/development/git/default.nix#L37)

Absolute path to apply the work git configuration.

**Type:** `string`

## [`options.snowflake.development.helix.enable`](modules/home/development/helix/default.nix#L9)

Whether to enable Enable helix development configuration.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.development.tmux.enable`](modules/home/development/tmux/default.nix#L7)

Whether to enable Enable tmux core configuration.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.extraPackages`](modules/nixos/core/default.nix#L14)

Extra packages to be installed system-wide

**Type:** `list of package`

**Default:** `[ ]`

## [`options.snowflake.gaming.proton.enable`](modules/nixos/gaming/proton/default.nix#L9)

Whether to enable Enable proton and related services for gaming.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.gaming.steam.enable`](modules/nixos/gaming/steam/default.nix#L8)

Whether to enable Enable steam.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.hardware.autofirma.enable`](modules/nixos/hardware/autofirma/default.nix#L9)

Whether to enable AutoFirma digital signature support.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.hardware.bluetooth.enable`](modules/nixos/hardware/bluetooth/default.nix#L9)

Whether to enable Enable bluetooth hardware support.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.hardware.btrfs-standard-layout.bootUUID`](modules/nixos/hardware/btrfs-standard-layout/default.nix#L57)

UUID of the EFI boot partition

**Type:** `string`

**Example:** `"7FBB-9E80"`

## [`options.snowflake.hardware.btrfs-standard-layout.enable`](modules/nixos/hardware/btrfs-standard-layout/default.nix#L43)

Whether to enable Use standard btrfs encrypted layout.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.hardware.btrfs-standard-layout.luksUUID`](modules/nixos/hardware/btrfs-standard-layout/default.nix#L51)

UUID of the LUKS encrypted device

**Type:** `string`

**Example:** `"9de352ea-128f-4d56-a720-36d81dfd9b92"`

## [`options.snowflake.hardware.btrfs-standard-layout.rootUUID`](modules/nixos/hardware/btrfs-standard-layout/default.nix#L45)

UUID of the decrypted btrfs root device

**Type:** `string`

**Example:** `"870fde90-a91a-4554-8b1c-d5702c789f4d"`

## [`options.snowflake.hardware.graphics.amd.enable`](modules/nixos/hardware/graphics/amd/default.nix#L9)

Whether to enable Enable AMD graphics configuration.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.hardware.graphics.intel.computeRuntime`](modules/nixos/hardware/graphics/intel/default.nix#L10)

intel-compute-runtime variant to use

**Type:** `package`

**Default:** `pkgs.intel-compute-runtime`

## [`options.snowflake.hardware.graphics.intel.driver`](modules/nixos/hardware/graphics/intel/default.nix#L15)

Whether to use i915 or experimental xe driver

**Type:** `one of "i915", "xe"`

**Default:** `"i915"`

## [`options.snowflake.hardware.graphics.intel.enable`](modules/nixos/hardware/graphics/intel/default.nix#L9)

Whether to enable Enable Intel graphics configuration.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.hardware.graphics.nvidia.busIDs.amd`](modules/nixos/hardware/graphics/nvidia/default.nix#L11)

The bus ID for your integrated AMD GPU. If you don't have an AMD GPU, you can leave this blank.

**Type:** `string`

**Default:** `""`

**Example:** `"PCI:101:0:0"`

## [`options.snowflake.hardware.graphics.nvidia.busIDs.intel`](modules/nixos/hardware/graphics/nvidia/default.nix#L17)

The bus ID for your integrated Intel GPU. If you don't have an Intel GPU, you can leave this blank.

**Type:** `string`

**Default:** `""`

**Example:** `"PCI:14:0:0"`

## [`options.snowflake.hardware.graphics.nvidia.busIDs.nvidia`](modules/nixos/hardware/graphics/nvidia/default.nix#L23)

The bus ID for your Nvidia GPU

**Type:** `string`

**Default:** `""`

**Example:** `"PCI:1:0:0"`

## [`options.snowflake.hardware.graphics.nvidia.enable`](modules/nixos/hardware/graphics/nvidia/default.nix#L9)

Whether to enable Enable Nvidia graphics configuration.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.hardware.initrd-luks.authorizedKeys`](modules/nixos/hardware/initrd-luks/default.nix#L25)

List of authorized keys for initrd-luks decyption

**Type:** `list of string`

**Default:** `[ ]`

## [`options.snowflake.hardware.initrd-luks.availableKernelModules`](modules/nixos/hardware/initrd-luks/default.nix#L30)

List of available kernel modules for initrd-luks decryption

**Type:** `list of string`

**Default:** `[ ]`

## [`options.snowflake.hardware.initrd-luks.enable`](modules/nixos/hardware/initrd-luks/default.nix#L8)

Whether to enable Enable initrd-luks hardware configuration.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.hardware.initrd-luks.hostKeys`](modules/nixos/hardware/initrd-luks/default.nix#L20)

Path to the host keys to use for initrd-luks decryption

**Type:** `list of string`

**Default:** `[ "/etc/ssh/ssh_host_ed25519_key" ]`

## [`options.snowflake.hardware.initrd-luks.shell`](modules/nixos/hardware/initrd-luks/default.nix#L15)

Shell to use for initrd-luks decryption

**Type:** `null or string`

**Default:** `null`

## [`options.snowflake.hardware.initrd-luks.sshPort`](modules/nixos/hardware/initrd-luks/default.nix#L10)

SSH Port to use for initrd-luks decryption

**Type:** `signed integer`

**Default:** `22`

## [`options.snowflake.hardware.usbguard.enable`](modules/nixos/hardware/usbguard/default.nix#L36)

Whether to enable Enable usbguard module, only installs the package.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.hardware.usbguard.rules`](modules/nixos/hardware/usbguard/default.nix#L44)

Usbguard rules for default devices which are allowed to be connected

**Type:** `string`

**Default:** `""`

## [`options.snowflake.hardware.usbguard.service.enable`](modules/nixos/hardware/usbguard/default.nix#L38)

Enable the usbguard service

**Type:** `boolean`

**Default:** `false`

## [`options.snowflake.hardware.yubico.enable`](modules/nixos/hardware/yubico/default.nix#L8)

Whether to enable Enable yubico hardware support.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.meta.domains.globalList`](modules/nixos/core/meta/default.nix#L18)

**Type:** `list of non-empty string`

**Default:**

```nix
self.nixosConfigurations
|> lib.mapAttrsToList (_: value: value.config.snowflake.meta.domains.list)
|> lib.concatLists
```

## [`options.snowflake.meta.domains.list`](modules/nixos/core/meta/default.nix#L11)

List of all the domains mapped to this host

**Type:** `list of non-empty string`

**Default:** `[ ]`

## [`options.snowflake.meta.ip.v4`](modules/nixos/core/meta/default.nix#L39)

The host ipv4 address to be used by services

**Type:** `string`

**Default:** `""`

## [`options.snowflake.meta.ip.v6`](modules/nixos/core/meta/default.nix#L45)

The host ipv6 address to be used by services

**Type:** `string`

**Default:** `""`

## [`options.snowflake.meta.ports.list`](modules/nixos/core/meta/default.nix#L30)

List of all the ports open on this host

**Type:** `list of port`

**Default:** `[ ]`

## [`options.snowflake.monitoring.enable`](modules/nixos/monitoring/default.nix#L7)

Whether to enable Enable the base monitoring stack configuration.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.monitoring.exporter.collectd.enable`](modules/nixos/monitoring/exporter/default.nix#L8)

Whether to enable Enable collectd exporter service.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.monitoring.exporter.node.enable`](modules/nixos/monitoring/exporter/default.nix#L9)

Whether to enable Enable node-exporter service.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.monitoring.exporter.systemd.enable`](modules/nixos/monitoring/exporter/default.nix#L10)

Whether to enable Enable systemd exporter service.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.networking.firewall.enable`](modules/nixos/networking/default.nix#L38)

Whether to enable Enable system firewall.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.networking.iwd.enable`](modules/nixos/networking/default.nix#L34)

Whether to enable Enable iwd backend for network manager.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.networking.mullvad.enable`](modules/nixos/networking/mullvad/default.nix#L8)

Whether to enable Enable Mullvad VPN client.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.networking.netbird.enable`](modules/nixos/networking/netbird/default.nix#L8)

Whether to enable Enable Netbird VPN client.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.networking.networkManager.enable`](modules/nixos/networking/default.nix#L36)

Whether to enable Enable network-manager.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.networking.networkd.enable`](modules/nixos/networking/default.nix#L35)

Whether to enable Enable systemd network management daemon.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.networking.resolved.enable`](modules/nixos/networking/default.nix#L37)

Whether to enable Enable systemd-resolved.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.networking.wifiProfiles.customProfiles`](modules/nixos/networking/default.nix#L59)


Additional custom NetworkManager profiles that don't follow the standard template.
Use this for networks requiring special configuration like enterprise authentication,
static IP addresses, or custom security settings.


**Type:** `attribute set`

**Default:** `{ }`

**Example:**

```nix
{
  "Enterprise-Network" = {
    connection = {
      id = "Enterprise Network";
      type = "wifi";
    };
    ipv4.method = "auto";
    ipv6 = {
      addr-gen-mode = "stable-privacy";
      method = "auto";
    };
    wifi = {
      mode = "infrastructure";
      ssid = "Enterprise WiFi";
    };
    wifi-security = {
      key-mgmt = "wpa-eap";
      eap = "peap";
      identity = "$ENTERPRISE_USERNAME";
      password = "$ENTERPRISE_PASSWORD";
    };
  };
  "Guest-Hotspot" = {
    connection = {
      id = "Guest Hotspot";
      type = "wifi";
    };
    ipv4.method = "auto";
    ipv6.method = "ignore";
    wifi = {
      mode = "infrastructure";
      ssid = "Guest-Network";
    };
    # Open network with no security
  };
}
```

## [`options.snowflake.networking.wifiProfiles.enable`](modules/nixos/networking/default.nix#L41)

Whether to enable Enable WiFi profile management.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.networking.wifiProfiles.environmentFiles`](modules/nixos/networking/default.nix#L43)

List of environment files containing WiFi credentials

**Type:** `list of path`

**Default:** `[ ]`

## [`options.snowflake.networking.wifiProfiles.networks`](modules/nixos/networking/default.nix#L49)

Map of WiFi SSIDs to their PSK environment variables

**Type:** `attribute set of string`

**Default:** `{ }`

**Example:**

```nix
{
  "My Network" = "$MY_NETWORK_PSK";
  "Office WiFi" = "$OFFICE_PSK";
}
```

## [`options.snowflake.nginx.wildcard-ssl.credentialFiles`](modules/nixos/services/wildcard-ssl/default.nix#L29)

Credential files for the DNS provider (passed as systemd credentials). Keys are environment variable names suffixed with _FILE.

**Type:** `attribute set of path`

**Default:** `{ }`

**Example:**

```nix
{ "CF_DNS_API_TOKEN_FILE" = config.age.secrets.cloudflare-api-token.path; }
```

## [`options.snowflake.nginx.wildcard-ssl.domains`](modules/nixos/services/wildcard-ssl/default.nix#L14)

**Type:** `attribute set of submodule`

**Default:** `{ }`

**Example:**

```nix
{
  snowflake.nginx.wildcard-ssl.domains."example.com".enable = true;
}
```

## [`options.snowflake.nginx.wildcard-ssl.domains.<name>.enable`](modules/nixos/services/wildcard-ssl/default.nix#L18)

Whether to enable Enable wildcard access for the given domain.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.nginx.wildcard-ssl.enable`](modules/nixos/services/wildcard-ssl/default.nix#L13)

Whether to enable Enable wildcard certificate generation for nginx.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.profile.laptop.enable`](modules/nixos/profiles/laptop/default.nix#L9)

Whether to enable Laptop-specific configuration.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.profile.server-performance.enable`](modules/nixos/profiles/server-performance/default.nix#L15)

Whether to enable Server performance tuning for high-connection workloads.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.profile.server.enable`](modules/nixos/profiles/server/default.nix#L11)

Whether to enable Server-specific configuration.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.profile.shared.enable`](modules/nixos/profiles/shared/default.nix#L10)

Whether to enable Shared base configuration for all hosts.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.actual.domain`](modules/nixos/services/actual-budget/default.nix#L10)

Configuration domain to use for the actual-budget service

**Type:** `string`

**Default:** `""`

## [`options.snowflake.services.actual.enable`](modules/nixos/services/actual-budget/default.nix#L8)

Whether to enable Enable actual-budget service.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.actual.port`](modules/nixos/services/actual-budget/default.nix#L16)

Configuration port to use for the actual-budget service

**Type:** `port`

**Default:** `5006`

## [`options.snowflake.services.arr.enable`](modules/nixos/services/arr/default.nix#L8)

Whether to enable Enable arr suite configuration.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.arr.monitoring.enable`](modules/nixos/services/arr/default.nix#L10)

Whether to enable Enable monitoring for arr suite.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.arr.monitoring.radarrApiKeyFile`](modules/nixos/services/arr/default.nix#L14)

Age module containing the radarr API Key to use for monitoring

**Type:** `any`

## [`options.snowflake.services.arr.monitoring.sonarrApiKeyFile`](modules/nixos/services/arr/default.nix#L11)

Age module containing the sonarr API Key to use for monitoring

**Type:** `any`

## [`options.snowflake.services.asus.enable`](modules/nixos/services/asus/default.nix#L7)

Whether to enable Enable Asus-specific configuration.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.atuin.domain`](modules/nixos/services/atuin/default.nix#L10)

Configuration domain to use for the atuin-server service

**Type:** `string`

**Default:** `""`

## [`options.snowflake.services.atuin.enable`](modules/nixos/services/atuin/default.nix#L8)

Whether to enable Enable atuin-server service.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.atuin.port`](modules/nixos/services/atuin/default.nix#L16)

Configuration port to use for the atuin-server service

**Type:** `port`

**Default:** `8888`

## [`options.snowflake.services.audiobookshelf.domain`](modules/nixos/services/arr/audiobookshelf/default.nix#L9)

Configuration domain to use for the audiobookshelf service

**Type:** `string`

**Default:** `""`

## [`options.snowflake.services.audiobookshelf.enable`](modules/nixos/services/arr/audiobookshelf/default.nix#L8)

Whether to enable Enable audiobookshelf deployment configuration.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.backups.config`](modules/nixos/services/backup/default.nix#L20)

**Type:** `attribute set of submodule`

**Default:** `{ }`

## [`options.snowflake.services.backups.config.<name>.dynamicFilesFrom`](modules/nixos/services/backup/default.nix#L27)


A script that produces a list of files to back up.
The result of this command are given to the `--files-from` option.


**Type:** `null or string`

**Default:** `null`

**Example:** `"find /home/user/repository -type d -name .git"`

## [`options.snowflake.services.backups.config.<name>.paths`](modules/nixos/services/backup/default.nix#L37)


List of paths to bck up. If null or an empty array,
no backup command will be run. This can be used to
create a prune-only job.


**Type:** `null or list of string`

**Default:** `null`

**Example:**

```nix
[
  "/etc/nixos"
  "/var/lib/postgresql"
]
```

## [`options.snowflake.services.backups.config.<name>.timerConfig`](modules/nixos/services/backup/default.nix#L60)


When to run the backup process. See man systemd.timer for details.


**Type:** `any`

**Default:**

```nix
{
  OnCalendar = "daily";
}
```

**Example:**

```nix
{
  OnCalendar = "00:05";
  RandomizedDelaySec = "5h";
}
```

## [`options.snowflake.services.backups.config.<name>.user`](modules/nixos/services/backup/default.nix#L51)


The user under which the backup should run.


**Type:** `string`

**Default:** `"root"`

**Example:** `"postgresql"`

## [`options.snowflake.services.backups.enable`](modules/nixos/services/backup/default.nix#L4)

Whether to enable Enable restic backup service.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.backups.repository`](modules/nixos/services/backup/default.nix#L14)

Repository to use as the restic endpoint. Must be in the form of <provider>:<repository>

**Type:** `string`

**Example:** `"b2:nix-backup-repository"`

## [`options.snowflake.services.backups.resticEnvironmentFile`](modules/nixos/services/backup/default.nix#L6)

Age module containing the restic environment details

**Type:** `any`

## [`options.snowflake.services.backups.resticPasswordFile`](modules/nixos/services/backup/default.nix#L10)

Age module containing the restic password

**Type:** `any`

## [`options.snowflake.services.bazarr.enable`](modules/nixos/services/arr/bazarr/default.nix#L8)

Whether to enable Enable bazarr deployment configuration.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.bluesky-pds.domain`](modules/nixos/services/bluesky-pds/default.nix#L9)

Domain to use for the Bluesky PDS

**Type:** `string`

## [`options.snowflake.services.bluesky-pds.enable`](modules/nixos/services/bluesky-pds/default.nix#L8)

Whether to enable Enable Bluesky PDS.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.bluesky-pds.environmentFile`](modules/nixos/services/bluesky-pds/default.nix#L13)

Environment variables file for the PDS server

**Type:** `any`

## [`options.snowflake.services.cloudflare-dyndns.apiTokenFile`](modules/nixos/services/cloudflare-dyndns/default.nix#L10)

Age module containing the Cloudflare API token for DDNS updates

**Type:** `any`

## [`options.snowflake.services.cloudflare-dyndns.domains`](modules/nixos/services/cloudflare-dyndns/default.nix#L14)

List of domains to update with dynamic DNS

**Type:** `list of string`

**Default:** `[ ]`

## [`options.snowflake.services.cloudflare-dyndns.enable`](modules/nixos/services/cloudflare-dyndns/default.nix#L8)

Whether to enable Enable Cloudflare Dynamic DNS service.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.cloudflare-dyndns.frequency`](modules/nixos/services/cloudflare-dyndns/default.nix#L20)

How often to check and update DNS (systemd timer format, default: every 5 minutes)

**Type:** `string`

**Default:** `"*:0/5"`

## [`options.snowflake.services.cloudflare-dyndns.proxied`](modules/nixos/services/cloudflare-dyndns/default.nix#L26)

Whether to enable Cloudflare proxy (orange cloud) for the domains

**Type:** `boolean`

**Default:** `false`

## [`options.snowflake.services.cross-seed.enable`](modules/nixos/services/arr/cross-seed/default.nix#L11)

Whether to enable Enable cross-seed for automatic cross-seeding.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.cross-seed.port`](modules/nixos/services/arr/cross-seed/default.nix#L13)

Port the cross-seed daemon listens on

**Type:** `port`

**Default:** `2468`

## [`options.snowflake.services.cross-seed.settings`](modules/nixos/services/arr/cross-seed/default.nix#L19)

cross-seed settings (non-secret). See https://cross-seed.org/docs/config/options

**Type:** `attribute set`

**Default:** `{ }`

## [`options.snowflake.services.cross-seed.settingsFile`](modules/nixos/services/arr/cross-seed/default.nix#L25)

Path to a JSON file with cross-seed secrets (e.g. torznab URLs with Prowlarr API key)

**Type:** `null or path`

**Default:** `null`

## [`options.snowflake.services.duperemove.enable`](modules/nixos/services/tools/duperemove/default.nix#L10)

Whether to enable Enable periodic filesystem de-duplication with duperemove.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.duperemove.extraArgs`](modules/nixos/services/tools/duperemove/default.nix#L38)

Extra arguments to pass to duperemove. Example: -d -r

**Type:** `string`

**Default:** `""`

## [`options.snowflake.services.duperemove.hashfile`](modules/nixos/services/tools/duperemove/default.nix#L19)


(Optional) Path to Hash file used for storing filesystem hashes. Significantly speeds up subsequent runs.


**Type:** `null or string`

**Default:** `null`

## [`options.snowflake.services.duperemove.package`](modules/nixos/services/tools/duperemove/default.nix#L12)

The duperemove package to use

**Type:** `package`

**Default:** `pkgs.duperemove`

## [`options.snowflake.services.duperemove.paths`](modules/nixos/services/tools/duperemove/default.nix#L28)


Paths to deduplicate. If you're using NixOS, the Nix Store can be deduplicated by nix itself. These paths
should point to other directories in that case for ex. /home/my-user


**Type:** `list of string`

**Default:** `[ ]`

## [`options.snowflake.services.duperemove.systemdInterval`](modules/nixos/services/tools/duperemove/default.nix#L45)

See systemd OnCalendar options (eg. daily, weekly)

**Type:** `string`

**Default:** `"daily"`

## [`options.snowflake.services.fail2ban.enable`](modules/nixos/services/fail2ban/default.nix#L8)

Whether to enable Enable fail2ban service.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.fail2ban.extraIgnoreIPs`](modules/nixos/services/fail2ban/default.nix#L10)

List of IPs to ignore for fail2ban alongside the default local subnets and loopback

**Type:** `list of string`

**Default:** `[ ]`

## [`options.snowflake.services.forgejo.actions-runner.enable`](modules/nixos/services/forgejo/default.nix#L43)

Whether to enable Enable a single-instance of forgejo-runner.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.forgejo.actions-runner.tokenFile`](modules/nixos/services/forgejo/default.nix#L44)

Age module containing the token to use for forgejo-runner

**Type:** `any`

## [`options.snowflake.services.forgejo.dbPasswordFile`](modules/nixos/services/forgejo/default.nix#L26)

Age module containing the postgresql password to use for forgejo

**Type:** `any`

## [`options.snowflake.services.forgejo.domain`](modules/nixos/services/forgejo/default.nix#L13)

Configuration domain to use for the forgejo service

**Type:** `string`

**Default:** `""`

## [`options.snowflake.services.forgejo.enable`](modules/nixos/services/forgejo/default.nix#L11)

Whether to enable Enable forgejo service.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.forgejo.httpPort`](modules/nixos/services/forgejo/default.nix#L30)

Configuration port for the forgejo service to listen on

**Type:** `signed integer`

**Default:** `3001`

## [`options.snowflake.services.forgejo.sshDomain`](modules/nixos/services/forgejo/default.nix#L19)

SSH domain to use for the forgejo service

**Type:** `string`

**Default:** `config.snowflake.services.forgejo.domain`

## [`options.snowflake.services.forgejo.sshPort`](modules/nixos/services/forgejo/default.nix#L36)

SSH port for the forgejo service to listen on

**Type:** `signed integer`

**Default:** `22022`

## [`options.snowflake.services.homebridge.enable`](modules/nixos/services/homebridge/default.nix#L8)

Whether to enable Enable homebridge service for Apple HomeKit.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.immich.domain`](modules/nixos/services/immich/default.nix#L12)

Configuration domain to use for the immich service

**Type:** `string`

**Default:** `""`

## [`options.snowflake.services.immich.enable`](modules/nixos/services/immich/default.nix#L9)

Whether to enable Enable immich service.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.immich.mediaLocation`](modules/nixos/services/immich/default.nix#L24)

Path to the immich media library

**Type:** `path`

**Default:** `"/storage/media/immich-library"`

## [`options.snowflake.services.immich.monitoring.enable`](modules/nixos/services/immich/default.nix#L10)

Whether to enable Enable immich monitoring.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.immich.port`](modules/nixos/services/immich/default.nix#L18)

Configuration port to use for the immich service

**Type:** `port`

**Default:** `9121`

## [`options.snowflake.services.jellyfin.domain`](modules/nixos/services/arr/jellyfin/default.nix#L9)

Configuration domain to use for the jellyfin service

**Type:** `string`

**Default:** `""`

## [`options.snowflake.services.jellyfin.enable`](modules/nixos/services/arr/jellyfin/default.nix#L8)

Whether to enable Enable jellyfin deployment configuration.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.mailserver.domains`](modules/nixos/services/mailserver/default.nix#L18)

Configuration domains to use for the mailserver

**Type:** `list of string`

**Default:** `[ ]`

## [`options.snowflake.services.mailserver.enable`](modules/nixos/services/mailserver/default.nix#L11)

Whether to enable Enable mailserver service.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.mailserver.fqdn`](modules/nixos/services/mailserver/default.nix#L13)

FQDN for the mailserver

**Type:** `string`

## [`options.snowflake.services.mailserver.loginAccounts`](modules/nixos/services/mailserver/default.nix#L24)

Login accounts for the domain. Every account is mapped to a unix user

**Type:** `attribute set of submodule`

**Default:** `{ }`

## [`options.snowflake.services.mailserver.loginAccounts.<name>.aliases`](modules/nixos/services/mailserver/default.nix#L33)

List of aliases for this account

**Type:** `list of string`

**Default:** `[ ]`

## [`options.snowflake.services.mailserver.loginAccounts.<name>.catchAll`](modules/nixos/services/mailserver/default.nix#L38)

List of domains for which this account should catch all emails

**Type:** `list of string`

**Default:** `[ ]`

## [`options.snowflake.services.mailserver.loginAccounts.<name>.hashedPasswordFile`](modules/nixos/services/mailserver/default.nix#L28)

Path to file containing the hashed password

**Type:** `null or string`

**Default:** `null`

## [`options.snowflake.services.mailserver.loginAccounts.<name>.sendOnly`](modules/nixos/services/mailserver/default.nix#L43)

Whether this account can only send emails

**Type:** `boolean`

**Default:** `false`

## [`options.snowflake.services.mailserver.postfixBindIPv6`](modules/nixos/services/mailserver/default.nix#L55)

The IPv6 bind address to use for postfix SMTP. Sets `smtp_bind_address6`

**Type:** `string`

## [`options.snowflake.services.miniflux.adminTokenFile`](modules/nixos/services/miniflux/default.nix#L16)

Age module containing the ADMIN_USERNAME and ADMIN_PASSWORD to use for miniflux

**Type:** `any`

## [`options.snowflake.services.miniflux.domain`](modules/nixos/services/miniflux/default.nix#L10)

Configuration domain to use for the miniflux service

**Type:** `string`

**Default:** `""`

## [`options.snowflake.services.miniflux.enable`](modules/nixos/services/miniflux/default.nix#L8)

Whether to enable Enable miniflux service.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.miniflux.port`](modules/nixos/services/miniflux/default.nix#L20)

Configuration port for the miniflux service to listen on

**Type:** `signed integer`

**Default:** `8816`

## [`options.snowflake.services.myModule.attributes`](templates/module/default.nix#L15)

An example of an attributes option.

**Type:** `attribute set`

**Default:** `{ }`

## [`options.snowflake.services.myModule.enable`](templates/module/default.nix#L14)

Whether to enable Enables this example module..

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.myModule.enum`](templates/module/default.nix#L30)

An example of an enum option.

**Type:** `one of "one", "two"`

**Default:** `"one"`

## [`options.snowflake.services.myModule.list`](templates/module/default.nix#L25)

An example of a list (of integers) option.

**Type:** `list of signed integer`

**Default:** `[ ]`

## [`options.snowflake.services.myModule.string`](templates/module/default.nix#L20)

An example of a string option.

**Type:** `string`

**Default:** `""`

## [`options.snowflake.services.navidrome.domain`](modules/nixos/services/navidrome/default.nix#L10)

Configuration domain to use for the navidrome service

**Type:** `string`

**Default:** `""`

## [`options.snowflake.services.navidrome.enable`](modules/nixos/services/navidrome/default.nix#L8)

Whether to enable Enable navidrome deployment configuration.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.navidrome.musicFolder`](modules/nixos/services/navidrome/default.nix#L22)

The music folder path to use for navidrome

**Type:** `string`

## [`options.snowflake.services.navidrome.port`](modules/nixos/services/navidrome/default.nix#L16)

The port to run navidrome on

**Type:** `port`

**Default:** `4533`

## [`options.snowflake.services.nginx.acmeEmail`](modules/nixos/services/nginx/default.nix#L9)

Email to use for ACME SSL certificates

**Type:** `string`

## [`options.snowflake.services.nginx.enable`](modules/nixos/services/nginx/default.nix#L8)

Whether to enable Enable nginx service.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.nginx.enableCloudflareRealIP`](modules/nixos/services/nginx/default.nix#L13)

Whether to enable Enable setting real_ip_header from Cloudflare IPs.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.ntfy-sh.domain`](modules/nixos/services/ntfy-sh/default.nix#L10)

Configuration domain to use for the ntfy-sh service

**Type:** `string`

**Default:** `""`

## [`options.snowflake.services.ntfy-sh.enable`](modules/nixos/services/ntfy-sh/default.nix#L8)

Whether to enable Enable ntfy-sh service.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.ntfy-sh.port`](modules/nixos/services/ntfy-sh/default.nix#L16)

Configuration port for the ntfy-sh service to listen on

**Type:** `signed integer`

**Default:** `8082`

## [`options.snowflake.services.paperless.adminUser`](modules/nixos/services/paperless/default.nix#L27)

Administrator username for the paperless service

**Type:** `string`

## [`options.snowflake.services.paperless.domain`](modules/nixos/services/paperless/default.nix#L11)

Configuration domain to use for the paperless service

**Type:** `string`

**Default:** `""`

## [`options.snowflake.services.paperless.enable`](modules/nixos/services/paperless/default.nix#L9)

Whether to enable Enable paperless service.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.paperless.passwordFile`](modules/nixos/services/paperless/default.nix#L23)

Age module containing the password to use for paperless

**Type:** `any`

## [`options.snowflake.services.paperless.port`](modules/nixos/services/paperless/default.nix#L17)

Configuration port to use for th paperless service

**Type:** `signed integer`

**Default:** `28981`

## [`options.snowflake.services.postgresql.backup.enable`](modules/nixos/services/postgresql/default.nix#L23)

Whether to enable Enable backup service for postgresql databases.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.postgresql.enable`](modules/nixos/services/postgresql/default.nix#L9)

Whether to enable Enable postgresql service.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.postgresql.enablePerformanceTuning`](modules/nixos/services/postgresql/default.nix#L17)

Enable performance tuning for PostgreSQL

**Type:** `boolean`

**Default:** `true`

## [`options.snowflake.services.postgresql.package`](modules/nixos/services/postgresql/default.nix#L11)

Package to use for the PostgreSQL service

**Type:** `package`

**Default:** `pkgs.postgresql_16`

## [`options.snowflake.services.prowlarr.enable`](modules/nixos/services/arr/prowlarr/default.nix#L8)

Whether to enable Enable prowlarr deployment configuration.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.qbittorrent-nox.dataDir`](modules/nixos/services/arr/qbittorrent/default.nix#L25)

The directory where qbittorrent-nox stores its data files

**Type:** `path`

**Default:** `"/var/lib/qbittorrent-nox"`

## [`options.snowflake.services.qbittorrent-nox.enable`](modules/nixos/services/arr/qbittorrent/default.nix#L9)

Whether to enable Enable qbittorrent-nox service configuration.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.qbittorrent-nox.group`](modules/nixos/services/arr/qbittorrent/default.nix#L19)

Group under which qbittorrent-nox runs

**Type:** `string`

**Default:** `"media"`

## [`options.snowflake.services.qbittorrent-nox.openFirewall`](modules/nixos/services/arr/qbittorrent/default.nix#L31)

Allow firewall access for qbittorrent-nox

**Type:** `boolean`

**Default:** `false`

## [`options.snowflake.services.qbittorrent-nox.package`](modules/nixos/services/arr/qbittorrent/default.nix#L11)

The qbittorrent-nox package to use.

**Type:** `package`

**Default:** `pkgs.qbittorrent-nox`

## [`options.snowflake.services.qbittorrent-nox.torrentPort`](modules/nixos/services/arr/qbittorrent/default.nix#L43)

Torrenting port

**Type:** `null or port`

**Default:** `64211`

## [`options.snowflake.services.qbittorrent-nox.ui.flood.enable`](modules/nixos/services/arr/qbittorrent/default.nix#L51)

Whether to enable Enable flood Web UI for qbittorrent-nox.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.qbittorrent-nox.ui.flood.host`](modules/nixos/services/arr/qbittorrent/default.nix#L59)

Interfaces that flood should listen on

**Type:** `string`

**Default:** `"0.0.0.0"`

## [`options.snowflake.services.qbittorrent-nox.ui.flood.port`](modules/nixos/services/arr/qbittorrent/default.nix#L53)

Flood web UI port

**Type:** `port`

**Default:** `8282`

## [`options.snowflake.services.qbittorrent-nox.ui.vuetorrent.enable`](modules/nixos/services/arr/qbittorrent/default.nix#L66)

Whether to enable Enable VueTorrent Web UI for qbittorrent-nox.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.qbittorrent-nox.uiPort`](modules/nixos/services/arr/qbittorrent/default.nix#L37)

Web UI Port for qbittorrent-nox

**Type:** `port`

**Default:** `8069`

## [`options.snowflake.services.qbittorrent-nox.user`](modules/nixos/services/arr/qbittorrent/default.nix#L13)

User account under which qbittorrent-nox runs

**Type:** `string`

**Default:** `"qbittorrent-nox"`

## [`options.snowflake.services.qui.enable`](modules/nixos/services/arr/qui/default.nix#L11)

Whether to enable Enable qui web UI for qbittorrent.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.qui.extraSettings`](modules/nixos/services/arr/qui/default.nix#L36)

Additional qui settings (see https://github.com/autobrr/qui)

**Type:** `attribute set`

**Default:** `{ }`

## [`options.snowflake.services.qui.host`](modules/nixos/services/arr/qui/default.nix#L19)

Host address qui listens on

**Type:** `string`

**Default:** `"0.0.0.0"`

## [`options.snowflake.services.qui.openFirewall`](modules/nixos/services/arr/qui/default.nix#L25)

Open firewall port for qui

**Type:** `boolean`

**Default:** `false`

## [`options.snowflake.services.qui.port`](modules/nixos/services/arr/qui/default.nix#L13)

Port qui listens on

**Type:** `port`

**Default:** `7476`

## [`options.snowflake.services.qui.secretFile`](modules/nixos/services/arr/qui/default.nix#L31)

Path to a file containing the session secret (generate with: openssl rand -hex 32)

**Type:** `path`

## [`options.snowflake.services.radarr.enable`](modules/nixos/services/arr/radarr/default.nix#L8)

Whether to enable Enable radarr deployment configuration.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.sabnzbd.enable`](modules/nixos/services/arr/sabnzbd/default.nix#L8)

Whether to enable Enable sabnzbd deployment configuration.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.seerr.domain`](modules/nixos/services/arr/jellyseerr/default.nix#L9)

Configuration domain to use for the seerr service

**Type:** `string`

**Default:** `""`

## [`options.snowflake.services.seerr.enable`](modules/nixos/services/arr/jellyseerr/default.nix#L8)

Whether to enable Enable seerr deployment configuration.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.seerr.port`](modules/nixos/services/arr/jellyseerr/default.nix#L14)

Configuration port to use for the seerr service

**Type:** `port`

**Default:** `5055`

## [`options.snowflake.services.sonarr.enable`](modules/nixos/services/arr/sonarr/default.nix#L8)

Whether to enable Enable sonarr deployment configuration.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.static-sites.sites`](modules/nixos/services/static-site/default.nix#L8)

Attribute set of static sites to configure

**Type:** `attribute set of submodule`

**Default:** `{ }`

## [`options.snowflake.services.static-sites.sites.<name>.domain`](modules/nixos/services/static-site/default.nix#L17)

Domain to use for the static site

**Type:** `string`

## [`options.snowflake.services.static-sites.sites.<name>.enable`](modules/nixos/services/static-site/default.nix#L12)

Whether to enable Enable this static site.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.static-sites.sites.<name>.extraConfig`](modules/nixos/services/static-site/default.nix#L21)

Additional nginx configuration for this virtual host

**Type:** `attribute set`

**Default:** `{ }`

## [`options.snowflake.services.static-sites.sites.<name>.package`](modules/nixos/services/static-site/default.nix#L13)

Package to use as a root directory for the static site

**Type:** `package`

## [`options.snowflake.services.technitium.enable`](modules/nixos/services/technitium/default.nix#L8)

Whether to enable Enable technitium dns server.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.unifi-controller.enable`](modules/nixos/services/unifi-controller/default.nix#L9)

Whether to enable Enable Unifi controller service for Unifi devices.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.unifi-controller.unpoller.enable`](modules/nixos/services/unifi-controller/default.nix#L11)

Whether to enable Enable unpoller metrics for Unifi controller.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.unifi-controller.unpoller.passwordFile`](modules/nixos/services/unifi-controller/default.nix#L19)

Age module containing the password to use for unpoller user

**Type:** `any`

## [`options.snowflake.services.unifi-controller.unpoller.url`](modules/nixos/services/unifi-controller/default.nix#L23)

URL for the unifi controller service

**Type:** `string`

**Default:** `"https://127.0.0.1:8443"`

## [`options.snowflake.services.unifi-controller.unpoller.user`](modules/nixos/services/unifi-controller/default.nix#L13)

Username for unpoller access to Unifi controller

**Type:** `string`

**Default:** `"unifi-unpoller"`

## [`options.snowflake.services.vaultwarden.adminTokenFile`](modules/nixos/services/vaultwarden/default.nix#L23)

Age module containing the ADMIN_TOKEN to use for vaultwarden

**Type:** `any`

## [`options.snowflake.services.vaultwarden.domain`](modules/nixos/services/vaultwarden/default.nix#L11)

Configuration domain to use for the vaultwarden service

**Type:** `string`

**Default:** `""`

## [`options.snowflake.services.vaultwarden.enable`](modules/nixos/services/vaultwarden/default.nix#L9)

Whether to enable Enable vaultwarden service with postgres and nginx.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.vaultwarden.port`](modules/nixos/services/vaultwarden/default.nix#L17)

Configuration port to use for the vaultwarden service

**Type:** `port`

**Default:** `33003`

## [`options.snowflake.shell.atuin.enable`](modules/home/shell/atuin/default.nix#L8)

Whether to enable Enable atuin shell home configuration.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.shell.atuin.sync.address`](modules/home/shell/atuin/default.nix#L10)

Host for the atuin sync server

**Type:** `string`

## [`options.snowflake.shell.atuin.sync.frequency`](modules/home/shell/atuin/default.nix#L14)

Sync frequency with the atuin sync server

**Type:** `string`

**Default:** `"15m"`

## [`options.snowflake.shell.direnv.enable`](modules/home/shell/direnv/default.nix#L7)

Whether to enable Enable direnv home configuration.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.shell.fish.enable`](modules/home/shell/fish/default.nix#L8)

Whether to enable Enable fish shell home configuration.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.stateVersion`](modules/nixos/core/default.nix#L9)

NixOS state version to use for this system

**Type:** `string`

**Example:** `"24.05"`

## [`options.snowflake.timeZone`](modules/nixos/core/default.nix#L19)

Timezone to use for the system

**Type:** `string`

**Default:** `"Europe/Madrid"`

## [`options.snowflake.user.description`](modules/nixos/user/default.nix#L25)

Real name for the system user

**Type:** `string`

## [`options.snowflake.user.enable`](modules/nixos/user/default.nix#L14)

Whether to enable Enable user configuration.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.user.extraAuthorizedKeys`](modules/nixos/user/default.nix#L33)

Additional authorized keys for the system user

**Type:** `list of string`

**Default:** `[ ]`

## [`options.snowflake.user.extraGroups`](modules/nixos/user/default.nix#L29)

**Type:** `list of string`

**Default:** `[ ]`

## [`options.snowflake.user.extraRootAuthorizedKeys`](modules/nixos/user/default.nix#L38)

Additional authorized keys for root user

**Type:** `list of string`

**Default:** `[ ]`

## [`options.snowflake.user.rootPasswordAgeModule`](modules/nixos/user/default.nix#L47)

Age file to include to use as root password

**Type:** `attribute set`

## [`options.snowflake.user.setEmptyPassword`](modules/nixos/user/default.nix#L51)

Whether to enable Enable to set empty password for the system user.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.user.setEmptyRootPassword`](modules/nixos/user/default.nix#L52)

Whether to enable Enable to set empty password for the root user.

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.user.uid`](modules/nixos/user/default.nix#L16)

User ID for the system user

**Type:** `null or signed integer`

**Default:** `1000`

## [`options.snowflake.user.userPasswordAgeModule`](modules/nixos/user/default.nix#L43)

Age file to include to use as user password

**Type:** `attribute set`

## [`options.snowflake.user.username`](modules/nixos/user/default.nix#L21)

Username for the system user

**Type:** `string`

---
*Generated with [nix-options-doc](https://github.com/Thunderbottom/nix-options-doc)*
