# NixOS Module Options


## [`options.snowflake.desktop.wezterm.enable`](modules/home/desktop/wezterm/default.nix#L9)

Enable wezterm home configuration

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.desktop.firefox.enable`](modules/home/desktop/firefox/default.nix#L8)

Enable firefox home configuration

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.desktop.ghostty.enable`](modules/home/desktop/ghostty/default.nix#L9)

Enable ghostty home configuration

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.desktop.gnome-dconf.enable`](modules/home/desktop/gnome/default.nix#L8)

Enable gnome dconf home configuration

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.development.git.enable`](modules/home/development/git/default.nix#L18)

Enable development git configuration

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.development.git.user.name`](modules/home/development/git/default.nix#L20)

Real name for the work git profile

**Type:** `lib.types.str`

## [`options.snowflake.development.git.user.email`](modules/home/development/git/default.nix#L24)

Email for the work git profile

**Type:** `lib.types.str`

## [`options.snowflake.development.git.user.signingKey`](modules/home/development/git/default.nix#L28)

Public GPG Key for the work git profile

**Type:** `lib.types.str`

## [`options.snowflake.development.git.work.enable`](modules/home/development/git/default.nix#L33)

Enable work git configuration

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.development.git.work.path`](modules/home/development/git/default.nix#L34)

Absolute path to apply the work git configuration.

**Type:** `lib.types.str`

## [`options.snowflake.development.git.work.extraConfig`](modules/home/development/git/default.nix#L38)

Additional configuration for work git.

**Type:** `lib.types.either lib.types.lines gitIniType`

**Default:** `{}`

## [`options.snowflake.development.git.work.email`](modules/home/development/git/default.nix#L43)

Email for the work git profile

**Type:** `lib.types.str`

## [`options.snowflake.development.helix.enable`](modules/home/development/helix/default.nix#L10)

Enable helix development configuration

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.development.tmux.enable`](modules/home/development/tmux/default.nix#L7)

Enable tmux core configuration

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.shell.fish.enable`](modules/home/shell/fish/default.nix#L8)

Enable fish shell home configuration

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.shell.direnv.enable`](modules/home/shell/direnv/default.nix#L7)

Enable direnv home configuration

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.core.docker.enable`](modules/nixos/core/docker/default.nix#L8)

Enable core docker configuration

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.core.docker.storageDriver`](modules/nixos/core/docker/default.nix#L9)

Storage driver backend to use for docker

**Type:** `lib.types.nullOr lib.types.str`

**Default:** `null`

## [`options.snowflake.core.fish.enable`](modules/nixos/core/fish/default.nix#L8)

Enable core fish configuration

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.core.gnupg.enable`](modules/nixos/core/gnupg/default.nix#L8)

Enable core gnupg configuration

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.core.lanzaboote.enable`](modules/nixos/core/lanzaboote/default.nix#L8)

Enable secure boot configuration

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.core.nix.enable`](modules/nixos/core/nix/default.nix#L10)

Enable core nix configuration

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.core.security.enable`](modules/nixos/core/security/default.nix#L8)

Enable core security configuration

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.core.security.sysctl.enable`](modules/nixos/core/security/default.nix#L9)

Enable sysctl security configuration

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.core.sshd.enable`](modules/nixos/core/sshd/default.nix#L8)

Enable core sshd configuration

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.stateVersion`](modules/nixos/core/default.nix#L10)

NixOS state version to use for this system

**Type:** `lib.types.str`

**Example:** `"24.05"`

## [`options.snowflake.extraPackages`](modules/nixos/core/default.nix#L15)

Extra packages to be installed system-wide

**Type:** `lib.types.listOf lib.types.package`

**Default:** `[]`

## [`options.snowflake.timeZone`](modules/nixos/core/default.nix#L20)

Timezone to use for the system

**Type:** `lib.types.str`

**Default:** `"Asia/Kolkata"`

## [`options.snowflake.bootloader`](modules/nixos/core/default.nix#L25)

Bootloader to use, can be either `systemd-boot` or `grub`

**Type:** `lib.types.enum ["systemd-boot" "grub"]`

**Default:** `"systemd-boot"`

## [`options.snowflake.desktop.fonts.enable`](modules/nixos/desktop/fonts/default.nix#L8)

Enable desktop font configuration

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.desktop.gnome.enable`](modules/nixos/desktop/gnome/default.nix#L10)

Enable the Gnome Desktop Environment

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.desktop.gnome.monitors.xml`](modules/nixos/desktop/gnome/default.nix#L11)

The monitors.xml configuration to use for gdm

**Type:** `lib.types.str`

**Default:** `""`

## [`options.snowflake.desktop.hyprland.enable`](modules/nixos/desktop/hyprland/default.nix#L10)

Enable the Hyprland Desktop Environment

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.desktop.kde.enable`](modules/nixos/desktop/kde/default.nix#L9)

Enable the KDE Plasma Desktop Environment

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.desktop.pipewire.enable`](modules/nixos/desktop/pipewire/default.nix#L10)

Enable pipewire configuration

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.desktop.pipewire.enableLowLatency`](modules/nixos/desktop/pipewire/default.nix#L11)

Enable low-latency audio (might cause crackling)

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.desktop.enable`](modules/nixos/desktop/default.nix#L10)

Enable core Desktop Environment configuration

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.desktop.fingerprint.enable`](modules/nixos/desktop/default.nix#L11)

Enable fingerprint support for Desktop Environments

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.desktop.plymouth.enable`](modules/nixos/desktop/plymouth/default.nix#L10)

Enable Plymouth for graphical boot animation

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.gaming.steam.enable`](modules/nixos/gaming/steam/default.nix#L8)

Enable steam

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.gaming.proton.enable`](modules/nixos/gaming/proton/default.nix#L8)

Enable proton and related services for gaming

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.hardware.bluetooth.enable`](modules/nixos/hardware/bluetooth/default.nix#L8)

Enable bluetooth hardware support

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.hardware.initrd-luks.enable`](modules/nixos/hardware/initrd-luks/default.nix#L8)

Enable initrd-luks hardware configuration

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.hardware.initrd-luks.sshPort`](modules/nixos/hardware/initrd-luks/default.nix#L10)

SSH Port to use for initrd-luks decryption

**Type:** `lib.types.int`

**Default:** `22`

## [`options.snowflake.hardware.initrd-luks.shell`](modules/nixos/hardware/initrd-luks/default.nix#L15)

Shell to use for initrd-luks decryption

**Type:** `lib.types.nullOr lib.types.str`

**Default:** `null`

## [`options.snowflake.hardware.initrd-luks.hostKeys`](modules/nixos/hardware/initrd-luks/default.nix#L20)

Path to the host keys to use for initrd-luks decryption

**Type:** `lib.types.listOf lib.types.str`

**Default:** `["/etc/ssh/ssh_host_ed25519_key"]`

## [`options.snowflake.hardware.initrd-luks.authorizedKeys`](modules/nixos/hardware/initrd-luks/default.nix#L25)

List of authorized keys for initrd-luks decyption

**Type:** `lib.types.listOf lib.types.str`

**Default:** `[]`

## [`options.snowflake.hardware.initrd-luks.availableKernelModules`](modules/nixos/hardware/initrd-luks/default.nix#L30)

List of available kernel modules for initrd-luks decryption

**Type:** `lib.types.listOf lib.types.str`

**Default:** `[]`

## [`options.snowflake.hardware.yubico.enable`](modules/nixos/hardware/yubico/default.nix#L8)

Enable yubico hardware support

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.hardware.usbguard.enable`](modules/nixos/hardware/usbguard/default.nix#L36)

Enable usbguard module, only installs the package

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.hardware.usbguard.service.enable`](modules/nixos/hardware/usbguard/default.nix#L38)

Enable the usbguard service

**Type:** `lib.types.bool`

**Default:** `false`

## [`options.snowflake.hardware.usbguard.rules`](modules/nixos/hardware/usbguard/default.nix#L44)

Usbguard rules for default devices which are allowed to be connected

**Type:** `lib.types.str`

**Default:** `""`

## [`options.snowflake.hardware.graphics.intel.enable`](modules/nixos/hardware/graphics/intel/default.nix#L9)

Enable Intel graphics configuration

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.hardware.graphics.intel.driver`](modules/nixos/hardware/graphics/intel/default.nix#L10)

Whether to use i915 or experimental xe driver

**Type:** `lib.types.enum ["i915" "xe"]`

**Default:** `"i915"`

## [`options.snowflake.hardware.graphics.nvidia.enable`](modules/nixos/hardware/graphics/nvidia/default.nix#L10)

Enable Nvidia graphics configuration

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.hardware.graphics.nvidia.busIDs.amd`](modules/nixos/hardware/graphics/nvidia/default.nix#L12)

The bus ID for your integrated AMD GPU. If you don't have an AMD GPU, you can leave this blank.

**Type:** `lib.types.str`

**Default:** `""`

**Example:** `"PCI:101:0:0"`

## [`options.snowflake.hardware.graphics.nvidia.busIDs.intel`](modules/nixos/hardware/graphics/nvidia/default.nix#L18)

The bus ID for your integrated Intel GPU. If you don't have an Intel GPU, you can leave this blank.

**Type:** `lib.types.str`

**Default:** `""`

**Example:** `"PCI:14:0:0"`

## [`options.snowflake.hardware.graphics.nvidia.busIDs.nvidia`](modules/nixos/hardware/graphics/nvidia/default.nix#L24)

The bus ID for your Nvidia GPU

**Type:** `lib.types.str`

**Default:** `""`

**Example:** `"PCI:1:0:0"`

## [`options.snowflake.hardware.graphics.amd.enable`](modules/nixos/hardware/graphics/amd/default.nix#L7)

Enable AMD graphics configuration

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.monitoring.exporter.collectd.enable`](modules/nixos/monitoring/exporter/default.nix#L8)

Enable collectd exporter service

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.monitoring.exporter.node.enable`](modules/nixos/monitoring/exporter/default.nix#L9)

Enable node-exporter service

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.monitoring.exporter.systemd.enable`](modules/nixos/monitoring/exporter/default.nix#L10)

Enable systemd exporter service

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.monitoring.enable`](modules/nixos/monitoring/default.nix#L7)

Enable the base monitoring stack configuration

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.networking.mullvad.enable`](modules/nixos/networking/mullvad/default.nix#L8)

Enable Mullvad VPN client

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.networking.netbird.enable`](modules/nixos/networking/netbird/default.nix#L8)

Enable Netbird VPN client

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.networking.iwd.enable`](modules/nixos/networking/default.nix#L8)

Enable iwd backend for network manager

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.networking.networkd.enable`](modules/nixos/networking/default.nix#L9)

Enable systemd network management daemon

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.networking.networkManager.enable`](modules/nixos/networking/default.nix#L10)

Enable network-manager

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.networking.resolved.enable`](modules/nixos/networking/default.nix#L11)

Enable systemd-resolved

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.networking.firewall.enable`](modules/nixos/networking/default.nix#L12)

Enable system firewall

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.bazarr.enable`](modules/nixos/services/arr/bazarr/default.nix#L8)

Enable bazarr deployment configuration

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.jellyfin.enable`](modules/nixos/services/arr/jellyfin/default.nix#L8)

Enable jellyfin deployment configuration

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.jellyseerr.enable`](modules/nixos/services/arr/jellyseerr/default.nix#L8)

Enable jellyseerr deployment configuration

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.prowlarr.enable`](modules/nixos/services/arr/prowlarr/default.nix#L8)

Enable prowlarr deployment configuration

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.qbittorrent-nox.enable`](modules/nixos/services/arr/qbittorrent/default.nix#L9)

Enable qbittorrent-nox service configuration

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.qbittorrent-nox.openFirewall`](modules/nixos/services/arr/qbittorrent/default.nix#L13)

Allow firewall access for qbittorrent-nox

**Type:** `lib.types.bool`

**Default:** `false`

## [`options.snowflake.services.qbittorrent-nox.uiPort`](modules/nixos/services/arr/qbittorrent/default.nix#L19)

Web UI Port for qbittorrent-nox

**Type:** `lib.types.port`

**Default:** `8069`

## [`options.snowflake.services.qbittorrent-nox.torrentPort`](modules/nixos/services/arr/qbittorrent/default.nix#L25)

Torrenting port

**Type:** `with lib.types; nullOr port`

**Default:** `64211`

## [`options.snowflake.services.radarr.enable`](modules/nixos/services/arr/radarr/default.nix#L8)

Enable radarr deployment configuration

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.sonarr.enable`](modules/nixos/services/arr/sonarr/default.nix#L8)

Enable sonarr deployment configuration

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.sabnzbd.enable`](modules/nixos/services/arr/sabnzbd/default.nix#L8)

Enable sabnzbd deployment configuration

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.arr.enable`](modules/nixos/services/arr/default.nix#L8)

Enable arr suite configuration

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.arr.monitoring.enable`](modules/nixos/services/arr/default.nix#L10)

Enable monitoring for arr suite

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.arr.monitoring.sonarrApiKeyFile`](modules/nixos/services/arr/default.nix#L11)

Age module containing the sonarr API Key to use for monitoring

**Type:** `any`

## [`options.snowflake.services.arr.monitoring.radarrApiKeyFile`](modules/nixos/services/arr/default.nix#L14)

Age module containing the radarr API Key to use for monitoring

**Type:** `any`

## [`options.snowflake.services.homebridge.enable`](modules/nixos/services/homebridge/default.nix#L7)

Enable homebridge service for Apple HomeKit

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.static-site.enable`](modules/nixos/services/maych-in/default.nix#L8)

Enable static site using nginx

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.static-site.package`](modules/nixos/services/maych-in/default.nix#L9)

Package to use as a root directory for the static site

**Type:** `lib.types.package`

## [`options.snowflake.services.static-site.domain`](modules/nixos/services/maych-in/default.nix#L13)

Domain to use for the static site

**Type:** `lib.types.str`

## [`options.snowflake.services.miniflux.enable`](modules/nixos/services/miniflux/default.nix#L8)

Enable miniflux service

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.miniflux.domain`](modules/nixos/services/miniflux/default.nix#L10)

Configuration domain to use for the miniflux service

**Type:** `lib.types.str`

**Default:** `""`

## [`options.snowflake.services.miniflux.adminTokenFile`](modules/nixos/services/miniflux/default.nix#L16)

Age module containing the ADMIN_USERNAME and ADMIN_PASSWORD to use for miniflux

**Type:** `any`

## [`options.snowflake.services.miniflux.listenPort`](modules/nixos/services/miniflux/default.nix#L20)

Configuration port for the miniflux service to listen on

**Type:** `lib.types.int`

**Default:** `8816`

## [`options.snowflake.services.paperless.enable`](modules/nixos/services/paperless/default.nix#L9)

Enable paperless service

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.paperless.domain`](modules/nixos/services/paperless/default.nix#L11)

Configuration domain to use for the paperless service

**Type:** `lib.types.str`

**Default:** `""`

## [`options.snowflake.services.paperless.passwordFile`](modules/nixos/services/paperless/default.nix#L17)

Age module containing the password to use for paperless

**Type:** `any`

## [`options.snowflake.services.paperless.adminUser`](modules/nixos/services/paperless/default.nix#L21)

Administrator username for the paperless service

**Type:** `lib.types.str`

## [`options.snowflake.services.unifi-controller.enable`](modules/nixos/services/unifi-controller/default.nix#L9)

Enable Unifi controller service for Unifi devices

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.unifi-controller.unpoller.enable`](modules/nixos/services/unifi-controller/default.nix#L11)

Enable unpoller metrics for Unifi controller

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.unifi-controller.unpoller.user`](modules/nixos/services/unifi-controller/default.nix#L13)

Username for unpoller access to Unifi controller

**Type:** `lib.types.str`

**Default:** `"unifi-unpoller"`

## [`options.snowflake.services.unifi-controller.unpoller.passwordFile`](modules/nixos/services/unifi-controller/default.nix#L19)

Age module containing the password to use for unpoller user

**Type:** `any`

## [`options.snowflake.services.unifi-controller.unpoller.url`](modules/nixos/services/unifi-controller/default.nix#L23)

URL for the unifi controller service

**Type:** `lib.types.str`

**Default:** `"https://127.0.0.1:8443"`

## [`options.snowflake.services.vaultwarden.enable`](modules/nixos/services/vaultwarden/default.nix#L9)

Enable vaultwarden service with postgres and nginx

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.vaultwarden.domain`](modules/nixos/services/vaultwarden/default.nix#L11)

Configuration domain to use for the vaultwarden service

**Type:** `lib.types.str`

**Default:** `""`

## [`options.snowflake.services.vaultwarden.adminTokenFile`](modules/nixos/services/vaultwarden/default.nix#L17)

Age module containing the ADMIN_TOKEN to use for vaultwarden

**Type:** `any`

## [`options.snowflake.services.ntfy-sh.enable`](modules/nixos/services/ntfy-sh/default.nix#L8)

Enable ntfy-sh service

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.ntfy-sh.domain`](modules/nixos/services/ntfy-sh/default.nix#L10)

Configuration domain to use for the ntfy-sh service

**Type:** `lib.types.str`

**Default:** `""`

## [`options.snowflake.services.ntfy-sh.listenPort`](modules/nixos/services/ntfy-sh/default.nix#L16)

Configuration port for the ntfy-sh service to listen on

**Type:** `lib.types.int`

**Default:** `8082`

## [`options.snowflake.services.immich.enable`](modules/nixos/services/immich/default.nix#L9)

Enable immich service

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.immich.monitoring.enable`](modules/nixos/services/immich/default.nix#L10)

Enable immich monitoring

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.immich.domain`](modules/nixos/services/immich/default.nix#L12)

Configuration domain to use for the immich service

**Type:** `lib.types.str`

**Default:** `""`

## [`options.snowflake.services.postgresql.enable`](modules/nixos/services/postgresql/default.nix#L9)

Enable postgresql service

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.postgresql.package`](modules/nixos/services/postgresql/default.nix#L11)

Package to use for the PostgreSQL service

**Type:** `lib.types.package`

**Default:** `pkgs.postgresql_16`

## [`options.snowflake.services.postgresql.backup.enable`](modules/nixos/services/postgresql/default.nix#L17)

Enable backup service for postgresql databases

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.fail2ban.enable`](modules/nixos/services/fail2ban/default.nix#L8)

Enable fail2ban service

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.fail2ban.extraIgnoreIPs`](modules/nixos/services/fail2ban/default.nix#L10)

List of IPs to ignore for fail2ban alongside the default local subnets and loopback

**Type:** `lib.types.listOf lib.types.str`

**Default:** `[]`

## [`options.snowflake.services.nginx.enable`](modules/nixos/services/nginx/default.nix#L9)

Enable nginx service

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.nginx.acmeEmail`](modules/nixos/services/nginx/default.nix#L10)

Email to use for ACME SSL certificates

**Type:** `lib.types.str`

## [`options.snowflake.services.nginx.enableCloudflareRealIP`](modules/nixos/services/nginx/default.nix#L14)

Enable setting real_ip_header from Cloudflare IPs

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.mailserver.enable`](modules/nixos/services/mailserver/default.nix#L12)

Enable mailserver service

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.mailserver.fqdn`](modules/nixos/services/mailserver/default.nix#L14)

FQDN for the mailserver

**Type:** `lib.types.str`

**Default:** `""`

## [`options.snowflake.services.mailserver.domains`](modules/nixos/services/mailserver/default.nix#L20)

Configuration domains to use for the mailserver

**Type:** `lib.types.listOf lib.types.str`

**Default:** `[ ]`

## [`options.snowflake.services.mailserver.loginAccounts`](modules/nixos/services/mailserver/default.nix#L26)

Login accounts for the domain. Every account is mapped to a unix user

**Type:** `any`

## [`options.snowflake.services.technitium.enable`](modules/nixos/services/technitium/default.nix#L8)

Enable technitium dns server

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.forgejo.enable`](modules/nixos/services/forgejo/default.nix#L9)

Enable forgejo service

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.forgejo.domain`](modules/nixos/services/forgejo/default.nix#L11)

Configuration domain to use for the forgejo service

**Type:** `lib.types.str`

**Default:** `""`

## [`options.snowflake.services.forgejo.sshDomain`](modules/nixos/services/forgejo/default.nix#L17)

SSH domain to use for the forgejo service

**Type:** `lib.types.str`

**Default:** `config.${namespace}.services.forgejo.domain`

## [`options.snowflake.services.forgejo.dbPasswordFile`](modules/nixos/services/forgejo/default.nix#L24)

Age module containing the postgresql password to use for forgejo

**Type:** `any`

## [`options.snowflake.services.forgejo.httpPort`](modules/nixos/services/forgejo/default.nix#L28)

Configuration port for the forgejo service to listen on

**Type:** `lib.types.int`

**Default:** `3001`

## [`options.snowflake.services.forgejo.sshPort`](modules/nixos/services/forgejo/default.nix#L34)

SSH port for the forgejo service to listen on

**Type:** `lib.types.int`

**Default:** `22022`

## [`options.snowflake.services.forgejo.actions-runner.enable`](modules/nixos/services/forgejo/default.nix#L41)

Enable a single-instance of forgejo-actions-runner

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.forgejo.actions-runner.tokenFile`](modules/nixos/services/forgejo/default.nix#L42)

Age module containing the token to use for forgejo-actions-runner

**Type:** `any`

## [`options.snowflake.services.navidrome.enable`](modules/nixos/services/navidrome/default.nix#L8)

Enable navidrome deployment configuration

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.services.navidrome.port`](modules/nixos/services/navidrome/default.nix#L10)

The port to run navidrome on

**Type:** `lib.types.port`

**Default:** `4533`

## [`options.snowflake.services.navidrome.musicFolder`](modules/nixos/services/navidrome/default.nix#L16)

The music folder path to use for navidrome

**Type:** `lib.types.str`

## [`options.snowflake.services.asus.enable`](modules/nixos/services/asus/default.nix#L8)

Enable Asus-specific configuration

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.user.enable`](modules/nixos/user/default.nix#L8)

Enable user configuration

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.user.uid`](modules/nixos/user/default.nix#L10)

User ID for the system user

**Type:** `lib.types.nullOr lib.types.int`

**Default:** `1000`

## [`options.snowflake.user.username`](modules/nixos/user/default.nix#L15)

Username for the system user

**Type:** `lib.types.str`

## [`options.snowflake.user.description`](modules/nixos/user/default.nix#L19)

Real name for the system user

**Type:** `lib.types.str`

## [`options.snowflake.user.extraGroups`](modules/nixos/user/default.nix#L23)

**Type:** `lib.types.listOf lib.types.str`

**Default:** `[]`

## [`options.snowflake.user.extraAuthorizedKeys`](modules/nixos/user/default.nix#L27)

Additional authorized keys for the system user

**Type:** `lib.types.listOf lib.types.str`

**Default:** `[]`

## [`options.snowflake.user.extraRootAuthorizedKeys`](modules/nixos/user/default.nix#L32)

Additional authorized keys for root user

**Type:** `lib.types.listOf lib.types.str`

**Default:** `[]`

## [`options.snowflake.user.userPasswordAgeModule`](modules/nixos/user/default.nix#L37)

Age file to include to use as user password

**Type:** `any`

## [`options.snowflake.user.rootPasswordAgeModule`](modules/nixos/user/default.nix#L40)

Age file to include to use as root password

**Type:** `any`

## [`options.snowflake.user.setEmptyPassword`](modules/nixos/user/default.nix#L43)

Enable to set empty password for the system user

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.snowflake.user.setEmptyRootPassword`](modules/nixos/user/default.nix#L44)

Enable to set empty password for the root user

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

---
*Generated with [nix-options-doc](https://github.com/Thunderbottom/nix-options-doc)*
