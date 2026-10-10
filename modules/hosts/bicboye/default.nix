{ nixos, ... }:
{
  configurations.nixos.bicboye.module =
    {
      config,
      inputs,
      lib,
      pkgs,
      ...
    }:
    let
      securityHeaders = ''
        add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
        add_header Referrer-Policy "strict-origin-when-cross-origin" always;
        add_header X-Content-Type-Options "nosniff" always;
        add_header X-Frame-Options "DENY" always;
        add_header Permissions-Policy "interest-cohort=(), geolocation=(), microphone=(), camera=()" always;
      '';
    in
    {
      imports = [
        nixos.server
        nixos.intel-graphics
        nixos.initrd-luks
        nixos.monitoring
        nixos.actual-budget
        nixos.atuin
        nixos.backups
        nixos.audiobookshelf
        nixos.arr
        nixos.qui
        nixos.bluesky-pds
        nixos.cloudflare-dyndns
        nixos.duperemove
        nixos.forgejo
        nixos.forgejo-runner
        nixos.harmonia
        nixos.immich
        nixos.miniflux
        nixos.ntfy-sh
        nixos.paperless
        nixos.postgresql-backup
        nixos.technitium
        ./_hardware.nix
        inputs.nixos-hardware.nixosModules.common-cpu-intel
      ];

      # Custom btrfs scrub for /storage (root filesystem scrub from server profile)
      services.btrfs.autoScrub = {
        enable = true;
        interval = "weekly";
        fileSystems = [ "/storage" ];
      };

      # Postgres + many concurrent services with plenty of headroom (32GB RAM) -
      # prefer reclaiming cache over swapping active service memory.
      boot.kernel.sysctl."vm.swappiness" = 10;

      networking = {
        interfaces.enp2s0 = {
          useDHCP = lib.mkDefault true;
          wakeOnLan.enable = true;
        };
      };

      # The RTL8125 2.5GbE chip is known to cause latency spikes/link
      # renegotiation stalls with Energy Efficient Ethernet enabled.
      services.udev.extraRules = ''
        ACTION=="add", SUBSYSTEM=="net", KERNEL=="enp2s0", RUN+="${pkgs.ethtool}/bin/ethtool --set-eee enp2s0 eee off"
      '';

      boot.initrd.availableKernelModules = [ "r8169" ];
      boot.initrd.network.ssh.authorizedKeys =
        config.profile.sshKeys.users.thunderbottom ++ config.profile.sshKeys.users.codingcoffee;

      environment.systemPackages = with pkgs; [
        nmap
        recyclarr
      ];

      profile.fullName = "Bicboye Server";

      hardware.graphics.extraPackages = [ pkgs.intel-compute-runtime ];

      services.fail2ban.ignoreIP = [ "192.168.69.0/16" ];

      services.cloudflare-dyndns.domains = [
        "maych.in"
        "bicboye.deku.moe"
      ];

      services.vmagent.prometheusConfig.scrape_configs = [
        {
          job_name = "unpoller";
          static_configs = [
            {
              targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.unpoller.port}" ];
            }
          ];
        }
        {
          job_name = "router";
          static_configs = [
            {
              targets = [ "192.168.69.1:9100" ];
            }
          ];
          relabel_configs = [
            {
              source_labels = [ "__address__" ];
              target_label = "instance";
              regex = "([^:]+)(:[0-9]+)?";
              replacement = "openwrt";
            }
          ];
        }
      ];

      services.nginx.virtualHosts = {
        maych-in = {
          serverName = "maych.in";
          enableACME = true;
          forceSSL = true;
          root = pkgs.maych-in;
          locations = {
            "^~ /_astro/" = {
              extraConfig = ''
                add_header Cache-Control "public, max-age=31536000, immutable" always;
              ''
              + securityHeaders;
            };
            "^~ /fonts/" = {
              extraConfig = ''
                add_header Cache-Control "public, max-age=31536000, immutable" always;
              ''
              + securityHeaders;
            };
            "^~ /icons/" = {
              extraConfig = ''
                add_header Cache-Control "public, max-age=31536000, immutable" always;
              ''
              + securityHeaders;
            };
            "~* \\.(xml|txt|webmanifest)$" = {
              extraConfig = ''
                add_header Cache-Control "public, max-age=3600" always;
              ''
              + securityHeaders;
            };
            "/" = {
              extraConfig = ''
                add_header Cache-Control "no-cache" always;
              ''
              + securityHeaders;
            };
          };
        };

        toasters = {
          serverName = "toaste.rs";
          enableACME = true;
          forceSSL = true;
          root = pkgs.toaste-rs;
        };
      };
    };
}
