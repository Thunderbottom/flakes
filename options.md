# NixOS Snowflake Module Options

The following module options are exposed by snowflake:

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| [`options.snowflake.user.enable`](modules/nixos/user/default.nix) | `boolean` | `false` | Enable user configuration |
| [`options.snowflake.user.uid`](modules/nixos/user/default.nix) | `lib.types.nullOr lib.types.int` | `1000` | User ID for the system user |
| [`options.snowflake.user.username`](modules/nixos/user/default.nix) | `lib.types.str` | `-` | Username for the system user |
| [`options.snowflake.user.description`](modules/nixos/user/default.nix) | `lib.types.str` | `-` | Real name for the system user |
| [`options.snowflake.user.extraGroups`](modules/nixos/user/default.nix) | `lib.types.listOf lib.types.str` | `[ ]` | - |
| [`options.snowflake.user.extraAuthorizedKeys`](modules/nixos/user/default.nix) | `lib.types.listOf lib.types.str` | `[ ]` | Additional authorized keys for the system user |
| [`options.snowflake.user.extraRootAuthorizedKeys`](modules/nixos/user/default.nix) | `lib.types.listOf lib.types.str` | `[ ]` | Additional authorized keys for root user |
| [`options.snowflake.user.userPasswordAgeModule`](modules/nixos/user/default.nix) | `any` | `-` | Age file to include to use as user password |
| [`options.snowflake.user.rootPasswordAgeModule`](modules/nixos/user/default.nix) | `any` | `-` | Age file to include to use as root password |
| [`options.snowflake.user.setEmptyPassword`](modules/nixos/user/default.nix) | `boolean` | `false` | Enable to set empty password for the system user |
| [`options.snowflake.user.setEmptyRootPassword`](modules/nixos/user/default.nix) | `boolean` | `false` | Enable to set empty password for the root user |
| [`options.snowflake.services.vaultwarden.enable`](modules/nixos/services/vaultwarden/default.nix) | `boolean` | `false` | Enable vaultwarden service with postgres and nginx |
| [`options.snowflake.services.vaultwarden.domain`](modules/nixos/services/vaultwarden/default.nix) | `lib.types.str` | `""` | Configuration domain to use for the vaultwarden service |
| [`options.snowflake.services.vaultwarden.adminTokenFile`](modules/nixos/services/vaultwarden/default.nix) | `any` | `-` | Age module containing the ADMIN_TOKEN to use for vaultwarden |
| [`options.snowflake.services.unifi-controller.enable`](modules/nixos/services/unifi-controller/default.nix) | `boolean` | `false` | Enable Unifi controller service for Unifi devices |
| [`options.snowflake.services.unifi-controller.unpoller.enable`](modules/nixos/services/unifi-controller/default.nix) | `boolean` | `false` | Enable unpoller metrics for Unifi controller |
| [`options.snowflake.services.unifi-controller.unpoller.user`](modules/nixos/services/unifi-controller/default.nix) | `lib.types.str` | `"unifi-unpoller"` | Username for unpoller access to Unifi controller |
| [`options.snowflake.services.unifi-controller.unpoller.passwordFile`](modules/nixos/services/unifi-controller/default.nix) | `any` | `-` | Age module containing the password to use for unpoller user |
| [`options.snowflake.services.unifi-controller.unpoller.url`](modules/nixos/services/unifi-controller/default.nix) | `lib.types.str` | `"https://127.0.0.1:8443"` | URL for the unifi controller service |
| [`options.snowflake.services.technitium.enable`](modules/nixos/services/technitium/default.nix) | `boolean` | `false` | Enable technitium dns server |
| [`options.snowflake.services.postgresql.enable`](modules/nixos/services/postgresql/default.nix) | `boolean` | `false` | Enable postgresql service |
| [`options.snowflake.services.postgresql.package`](modules/nixos/services/postgresql/default.nix) | `lib.types.package` | `pkgs.postgresql_16` | Package to use for the PostgreSQL service |
| [`options.snowflake.services.postgresql.backup.enable`](modules/nixos/services/postgresql/default.nix) | `boolean` | `false` | Enable backup service for postgresql databases |
| [`options.snowflake.services.paperless.enable`](modules/nixos/services/paperless/default.nix) | `boolean` | `false` | Enable paperless service |
| [`options.snowflake.services.paperless.domain`](modules/nixos/services/paperless/default.nix) | `lib.types.str` | `""` | Configuration domain to use for the paperless service |
| [`options.snowflake.services.paperless.passwordFile`](modules/nixos/services/paperless/default.nix) | `any` | `-` | Age module containing the password to use for paperless |
| [`options.snowflake.services.paperless.adminUser`](modules/nixos/services/paperless/default.nix) | `lib.types.str` | `-` | Administrator username for the paperless service |
| [`options.snowflake.services.ntfy-sh.enable`](modules/nixos/services/ntfy-sh/default.nix) | `boolean` | `false` | Enable ntfy-sh service |
| [`options.snowflake.services.ntfy-sh.domain`](modules/nixos/services/ntfy-sh/default.nix) | `lib.types.str` | `""` | Configuration domain to use for the ntfy-sh service |
| [`options.snowflake.services.ntfy-sh.listenPort`](modules/nixos/services/ntfy-sh/default.nix) | `lib.types.int` | `8082` | Configuration port for the ntfy-sh service to listen on |
| [`options.snowflake.services.nginx.enable`](modules/nixos/services/nginx/default.nix) | `boolean` | `false` | Enable nginx service |
| [`options.snowflake.services.nginx.acmeEmail`](modules/nixos/services/nginx/default.nix) | `lib.types.str` | `-` | Email to use for ACME SSL certificates |
| [`options.snowflake.services.nginx.enableCloudflareRealIP`](modules/nixos/services/nginx/default.nix) | `boolean` | `false` | Enable setting real_ip_header from Cloudflare IPs |
| [`options.snowflake.services.navidrome.enable`](modules/nixos/services/navidrome/default.nix) | `boolean` | `false` | Enable navidrome deployment configuration |
| [`options.snowflake.services.navidrome.port`](modules/nixos/services/navidrome/default.nix) | `lib.types.port` | `4533` | The port to run navidrome on |
| [`options.snowflake.services.navidrome.musicFolder`](modules/nixos/services/navidrome/default.nix) | `lib.types.str` | `-` | The music folder path to use for navidrome |
| [`options.snowflake.services.miniflux.enable`](modules/nixos/services/miniflux/default.nix) | `boolean` | `false` | Enable miniflux service |
| [`options.snowflake.services.miniflux.domain`](modules/nixos/services/miniflux/default.nix) | `lib.types.str` | `""` | Configuration domain to use for the miniflux service |
| [`options.snowflake.services.miniflux.adminTokenFile`](modules/nixos/services/miniflux/default.nix) | `any` | `-` | Age module containing the ADMIN_USERNAME and ADMIN_PASSWORD to use for miniflux |
| [`options.snowflake.services.miniflux.listenPort`](modules/nixos/services/miniflux/default.nix) | `lib.types.int` | `8816` | Configuration port for the miniflux service to listen on |
| [`options.snowflake.services.static-site.enable`](modules/nixos/services/maych-in/default.nix) | `boolean` | `false` | Enable static site using nginx |
| [`options.snowflake.services.static-site.package`](modules/nixos/services/maych-in/default.nix) | `lib.types.package` | `-` | Package to use as a root directory for the static site |
| [`options.snowflake.services.static-site.domain`](modules/nixos/services/maych-in/default.nix) | `lib.types.str` | `-` | Domain to use for the static site |
| [`options.snowflake.services.mailserver.enable`](modules/nixos/services/mailserver/default.nix) | `boolean` | `false` | Enable mailserver service |
| [`options.snowflake.services.mailserver.fqdn`](modules/nixos/services/mailserver/default.nix) | `lib.types.str` | `-` | FQDN for the mailserver |
| [`options.snowflake.services.mailserver.domains`](modules/nixos/services/mailserver/default.nix) | `lib.types.listOf lib.types.str` | `[]` | Configuration domains to use for the mailserver |
| [`options.snowflake.services.mailserver.loginAccounts`](modules/nixos/services/mailserver/default.nix) | `any` | `-` | Login accounts for the domain. Every account is mapped to a unix user |
| [`options.snowflake.services.immich.enable`](modules/nixos/services/immich/default.nix) | `boolean` | `false` | Enable immich service |
| [`options.snowflake.services.immich.monitoring.enable`](modules/nixos/services/immich/default.nix) | `boolean` | `false` | Enable immich monitoring |
| [`options.snowflake.services.immich.domain`](modules/nixos/services/immich/default.nix) | `lib.types.str` | `""` | Configuration domain to use for the immich service |
| [`options.snowflake.services.homebridge.enable`](modules/nixos/services/homebridge/default.nix) | `boolean` | `false` | Enable homebridge service for Apple HomeKit |
| [`options.snowflake.services.forgejo.enable`](modules/nixos/services/forgejo/default.nix) | `boolean` | `false` | Enable forgejo service |
| [`options.snowflake.services.forgejo.domain`](modules/nixos/services/forgejo/default.nix) | `lib.types.str` | `-` | Configuration domain to use for the forgejo service |
| [`options.snowflake.services.forgejo.sshDomain`](modules/nixos/services/forgejo/default.nix) | `lib.types.str` | `-` | SSH domain to use for the forgejo service |
| [`options.snowflake.services.forgejo.dbPasswordFile`](modules/nixos/services/forgejo/default.nix) | `any` | `-` | Age module containing the postgresql password to use for forgejo |
| [`options.snowflake.services.forgejo.httpPort`](modules/nixos/services/forgejo/default.nix) | `lib.types.int` | `3001` | Configuration port for the forgejo service to listen on |
| [`options.snowflake.services.forgejo.sshPort`](modules/nixos/services/forgejo/default.nix) | `lib.types.int` | `22022` | SSH port for the forgejo service to listen on |
| [`options.snowflake.services.forgejo.actions-runner.enable`](modules/nixos/services/forgejo/default.nix) | `boolean` | `false` | Enable a single-instance of forgejo-actions-runner |
| [`options.snowflake.services.forgejo.actions-runner.tokenFile`](modules/nixos/services/forgejo/default.nix) | `any` | `-` | Age module containing the token to use for forgejo-actions-runner |
| [`options.snowflake.services.fail2ban.enable`](modules/nixos/services/fail2ban/default.nix) | `boolean` | `false` | Enable fail2ban service |
| [`options.snowflake.services.fail2ban.extraIgnoreIPs`](modules/nixos/services/fail2ban/default.nix) | `lib.types.listOf lib.types.str` | `[]` | List of IPs to ignore for fail2ban alongside the default local subnets and loopback |
| [`options.snowflake.services.asus.enable`](modules/nixos/services/asus/default.nix) | `boolean` | `false` | Enable Asus-specific configuration |
| [`options.snowflake.services.sonarr.enable`](modules/nixos/services/arr/sonarr/default.nix) | `boolean` | `false` | Enable sonarr deployment configuration |
| [`options.snowflake.services.sabnzbd.enable`](modules/nixos/services/arr/sabnzbd/default.nix) | `boolean` | `false` | Enable sabnzbd deployment configuration |
| [`options.snowflake.services.radarr.enable`](modules/nixos/services/arr/radarr/default.nix) | `boolean` | `false` | Enable radarr deployment configuration |
| [`options.snowflake.services.qbittorrent-nox.enable`](modules/nixos/services/arr/qbittorrent/default.nix) | `boolean` | `false` | Enable qbittorrent-nox service configuration |
| [`options.snowflake.services.qbittorrent-nox.openFirewall`](modules/nixos/services/arr/qbittorrent/default.nix) | `lib.types.bool` | `false` | Allow firewall access for qbittorrent-nox |
| [`options.snowflake.services.qbittorrent-nox.uiPort`](modules/nixos/services/arr/qbittorrent/default.nix) | `lib.types.port` | `8069` | Web UI Port for qbittorrent-nox |
| [`options.snowflake.services.qbittorrent-nox.torrentPort`](modules/nixos/services/arr/qbittorrent/default.nix) | `with lib.types; nullOr port` | `64211` | Torrenting port |
| [`options.snowflake.services.prowlarr.enable`](modules/nixos/services/arr/prowlarr/default.nix) | `boolean` | `false` | Enable prowlarr deployment configuration |
| [`options.snowflake.services.jellyseerr.enable`](modules/nixos/services/arr/jellyseerr/default.nix) | `boolean` | `false` | Enable jellyseerr deployment configuration |
| [`options.snowflake.services.jellyfin.enable`](modules/nixos/services/arr/jellyfin/default.nix) | `boolean` | `false` | Enable jellyfin deployment configuration |
| [`options.snowflake.services.arr.enable`](modules/nixos/services/arr/default.nix) | `boolean` | `false` | Enable arr suite configuration |
| [`options.snowflake.services.arr.monitoring.enable`](modules/nixos/services/arr/default.nix) | `boolean` | `false` | Enable monitoring for arr suite |
| [`options.snowflake.services.arr.monitoring.sonarrApiKeyFile`](modules/nixos/services/arr/default.nix) | `any` | `-` | Age module containing the sonarr API Key to use for monitoring |
| [`options.snowflake.services.arr.monitoring.radarrApiKeyFile`](modules/nixos/services/arr/default.nix) | `any` | `-` | Age module containing the radarr API Key to use for monitoring |
| [`options.snowflake.services.bazarr.enable`](modules/nixos/services/arr/bazarr/default.nix) | `boolean` | `false` | Enable bazarr deployment configuration |
| [`options.snowflake.networking.netbird.enable`](modules/nixos/networking/netbird/default.nix) | `boolean` | `false` | Enable Netbird VPN client |
| [`options.snowflake.networking.mullvad.enable`](modules/nixos/networking/mullvad/default.nix) | `boolean` | `false` | Enable Mullvad VPN client |
| [`options.snowflake.networking.iwd.enable`](modules/nixos/networking/default.nix) | `boolean` | `false` | Enable iwd backend for network manager |
| [`options.snowflake.networking.networkd.enable`](modules/nixos/networking/default.nix) | `boolean` | `false` | Enable systemd network management daemon |
| [`options.snowflake.networking.networkManager.enable`](modules/nixos/networking/default.nix) | `boolean` | `false` | Enable network-manager |
| [`options.snowflake.networking.resolved.enable`](modules/nixos/networking/default.nix) | `boolean` | `false` | Enable systemd-resolved |
| [`options.snowflake.networking.firewall.enable`](modules/nixos/networking/default.nix) | `boolean` | `false` | Enable system firewall |
| [`options.snowflake.monitoring.exporter.collectd.enable`](modules/nixos/monitoring/exporter/default.nix) | `boolean` | `false` | Enable collectd exporter service |
| [`options.snowflake.monitoring.exporter.node.enable`](modules/nixos/monitoring/exporter/default.nix) | `boolean` | `false` | Enable node-exporter service |
| [`options.snowflake.monitoring.exporter.systemd.enable`](modules/nixos/monitoring/exporter/default.nix) | `boolean` | `false` | Enable systemd exporter service |
| [`options.snowflake.monitoring.enable`](modules/nixos/monitoring/default.nix) | `boolean` | `false` | Enable the base monitoring stack configuration |
| [`options.snowflake.hardware.yubico.enable`](modules/nixos/hardware/yubico/default.nix) | `boolean` | `false` | Enable yubico hardware support |
| [`options.snowflake.hardware.usbguard.enable`](modules/nixos/hardware/usbguard/default.nix) | `boolean` | `false` | Enable usbguard module, only installs the package |
| [`options.snowflake.hardware.usbguard.service.enable`](modules/nixos/hardware/usbguard/default.nix) | `lib.types.bool` | `false` | Enable the usbguard service |
| [`options.snowflake.hardware.usbguard.rules`](modules/nixos/hardware/usbguard/default.nix) | `lib.types.str` | `""` | Usbguard rules for default devices which are allowed to be connected |
| [`options.snowflake.hardware.initrd-luks.enable`](modules/nixos/hardware/initrd-luks/default.nix) | `boolean` | `false` | Enable initrd-luks hardware configuration |
| [`options.snowflake.hardware.initrd-luks.sshPort`](modules/nixos/hardware/initrd-luks/default.nix) | `lib.types.int` | `22` | SSH Port to use for initrd-luks decryption |
| [`options.snowflake.hardware.initrd-luks.shell`](modules/nixos/hardware/initrd-luks/default.nix) | `lib.types.nullOr lib.types.str` | `null` | Shell to use for initrd-luks decryption |
| [`options.snowflake.hardware.initrd-luks.hostKeys`](modules/nixos/hardware/initrd-luks/default.nix) | `lib.types.listOf lib.types.str` | `["/etc/ssh/ssh_host_ed25519_key"]` | Path to the host keys to use for initrd-luks decryption |
| [`options.snowflake.hardware.initrd-luks.authorizedKeys`](modules/nixos/hardware/initrd-luks/default.nix) | `lib.types.listOf lib.types.str` | `[]` | List of authorized keys for initrd-luks decyption |
| [`options.snowflake.hardware.initrd-luks.availableKernelModules`](modules/nixos/hardware/initrd-luks/default.nix) | `lib.types.listOf lib.types.str` | `[]` | List of available kernel modules for initrd-luks decryption |
| [`options.snowflake.hardware.graphics.nvidia.enable`](modules/nixos/hardware/graphics/nvidia/default.nix) | `boolean` | `false` | Enable Nvidia graphics configuration |
| [`options.snowflake.hardware.graphics.intel.enable`](modules/nixos/hardware/graphics/intel/default.nix) | `boolean` | `false` | Enable Intel graphics configuration |
| [`options.snowflake.hardware.graphics.intel.driver`](modules/nixos/hardware/graphics/intel/default.nix) | `lib.types.enum ["i915" "xe"]` | `"i915"` | Whether to use i915 or experimental xe driver |
| [`options.snowflake.hardware.graphics.amd.enable`](modules/nixos/hardware/graphics/amd/default.nix) | `boolean` | `false` | Enable AMD graphics configuration |
| [`options.snowflake.hardware.bluetooth.enable`](modules/nixos/hardware/bluetooth/default.nix) | `boolean` | `false` | Enable bluetooth hardware support |
| [`options.snowflake.gaming.steam.enable`](modules/nixos/gaming/steam/default.nix) | `boolean` | `false` | Enable steam |
| [`options.snowflake.gaming.proton.enable`](modules/nixos/gaming/proton/default.nix) | `boolean` | `false` | Enable proton and related services for gaming |
| [`options.snowflake.desktop.pipewire.enable`](modules/nixos/desktop/pipewire/default.nix) | `boolean` | `false` | Enable pipewire configuration |
| [`options.snowflake.desktop.kde.enable`](modules/nixos/desktop/kde/default.nix) | `boolean` | `false` | Enable the KDE Plasma Desktop Environment |
| [`options.snowflake.desktop.hyprland.enable`](modules/nixos/desktop/hyprland/default.nix) | `boolean` | `false` | Enable the Hyprland Desktop Environment |
| [`options.snowflake.desktop.gnome.enable`](modules/nixos/desktop/gnome/default.nix) | `boolean` | `false` | Enable the Gnome Desktop Environment |
| [`options.snowflake.desktop.fonts.enable`](modules/nixos/desktop/fonts/default.nix) | `boolean` | `false` | Enable desktop font configuration |
| [`options.snowflake.desktop.enable`](modules/nixos/desktop/default.nix) | `boolean` | `false` | Enable core Desktop Environment configuration |
| [`options.snowflake.desktop.fingerprint.enable`](modules/nixos/desktop/default.nix) | `boolean` | `false` | Enable fingerprint support for Desktop Environments |
| [`options.snowflake.core.sshd.enable`](modules/nixos/core/sshd/default.nix) | `boolean` | `false` | Enable core sshd configuration |
| [`options.snowflake.core.security.enable`](modules/nixos/core/security/default.nix) | `boolean` | `false` | Enable core security configuration |
| [`options.snowflake.core.security.sysctl.enable`](modules/nixos/core/security/default.nix) | `boolean` | `false` | Enable sysctl security configuration |
| [`options.snowflake.core.nix.enable`](modules/nixos/core/nix/default.nix) | `boolean` | `false` | Enable core nix configuration |
| [`options.snowflake.core.lanzaboote.enable`](modules/nixos/core/lanzaboote/default.nix) | `boolean` | `false` | Enable secure boot configuration |
| [`options.snowflake.core.gnupg.enable`](modules/nixos/core/gnupg/default.nix) | `boolean` | `false` | Enable core gnupg configuration |
| [`options.snowflake.core.fish.enable`](modules/nixos/core/fish/default.nix) | `boolean` | `false` | Enable core fish configuration |
| [`options.snowflake.core.docker.enable`](modules/nixos/core/docker/default.nix) | `boolean` | `false` | Enable core docker configuration |
| [`options.snowflake.core.docker.storageDriver`](modules/nixos/core/docker/default.nix) | `lib.types.nullOr lib.types.str` | `null` | Storage driver backend to use for docker |
| [`options.snowflake.stateVersion`](modules/nixos/core/default.nix) | `lib.types.str` | `-` | NixOS state version to use for this system |
| [`options.snowflake.extraPackages`](modules/nixos/core/default.nix) | `lib.types.listOf lib.types.package` | `[]` | Extra packages to be installed system-wide |
| [`options.snowflake.timeZone`](modules/nixos/core/default.nix) | `lib.types.str` | `"Asia/Kolkata"` | Timezone to use for the system |
| [`options.snowflake.bootloader`](modules/nixos/core/default.nix) | `lib.types.enum ["systemd-boot" "grub"]` | `"systemd-boot"` | Bootloader to use, can be either `systemd-boot` or `grub` |
| [`options.snowflake.shell.fish.enable`](modules/home/shell/fish/default.nix) | `boolean` | `false` | Enable fish shell home configuration |
| [`options.snowflake.development.tmux.enable`](modules/home/development/tmux/default.nix) | `boolean` | `false` | Enable tmux core configuration |
| [`options.snowflake.development.helix.enable`](modules/home/development/helix/default.nix) | `boolean` | `false` | Enable helix development configuration |
| [`options.snowflake.development.git.enable`](modules/home/development/git/default.nix) | `boolean` | `false` | Enable development git configuration |
| [`options.snowflake.development.git.user.name`](modules/home/development/git/default.nix) | `lib.types.str` | `-` | Real name for the work git profile |
| [`options.snowflake.development.git.user.email`](modules/home/development/git/default.nix) | `lib.types.str` | `-` | Email for the work git profile |
| [`options.snowflake.development.git.user.signingKey`](modules/home/development/git/default.nix) | `lib.types.str` | `-` | Public GPG Key for the work git profile |
| [`options.snowflake.development.git.work.enable`](modules/home/development/git/default.nix) | `boolean` | `false` | Enable work git configuration |
| [`options.snowflake.development.git.work.path`](modules/home/development/git/default.nix) | `lib.types.str` | `-` | Absolute path to apply the work git configuration. |
| [`options.snowflake.development.git.work.extraConfig`](modules/home/development/git/default.nix) | `lib.types.either lib.types.lines gitIniType` | `{ }` | Additional configuration for work git. |
| [`options.snowflake.development.git.work.email`](modules/home/development/git/default.nix) | `lib.types.str` | `-` | Email for the work git profile |
| [`options.snowflake.desktop.wezterm.enable`](modules/home/desktop/wezterm/default.nix) | `boolean` | `false` | Enable wezterm home configuration |
| [`options.snowflake.desktop.firefox.enable`](modules/home/desktop/firefox/default.nix) | `boolean` | `false` | Enable firefox home configuration |


*Generated from NixOS module declarations*
