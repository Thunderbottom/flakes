{ nixos, ... }:
{
  configurations.nixos.bicboye.module =
    {
      config,
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

      # ssh2rce.com is a static site with a strict CSP of its own. The page looks
      # up the visitor's address at /cdn-cgi/trace (same origin), so connect-src
      # stays on 'self' and nothing is sent to a third party.
      ssh2rceHeaders = ''
        add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
        add_header Content-Security-Policy "default-src 'none'; script-src 'self'; style-src 'self'; img-src 'self'; connect-src 'self'; base-uri 'none'; form-action 'none'; frame-ancestors 'none'" always;
        add_header Referrer-Policy "no-referrer" always;
        add_header X-Content-Type-Options "nosniff" always;
        add_header X-Frame-Options "DENY" always;
        add_header Permissions-Policy "camera=(), microphone=(), geolocation=(), interest-cohort=()" always;
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
        ./_hardware.nix
      ];

      hardware.facter = {
        enable = true;
        reportPath = ./facter.json;
        # Graphics stack is owned by nixos.intel-graphics (and the jellyfin override).
        detected.graphics.enable = false;
      };

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

      services.fail2ban.ignoreIP = [ "192.168.1.0/16" ];

      services.cloudflare-dyndns.domains = [
        "maych.in"
        "ssh2rce.com"
        "bicboye.deku.moe"
      ];

      services.nginx.virtualHosts = {
        maych-in = {
          serverName = "maych.in";
          enableACME = true;
          forceSSL = true;
          root = pkgs.maych-in;
          locations = {
            "~ ^/(?:_astro|fonts|icons)/" = {
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

        ssh2rce = {
          serverName = "ssh2rce.com";
          enableACME = true;
          forceSSL = true;
          root = pkgs.ssh2rce;
          locations = {
            # Mirrors Cloudflare's /cdn-cgi/trace, which the page asks for first.
            # Answering it here shows the visitor their own address without
            # calling out to anyone.
            "= /cdn-cgi/trace" = {
              extraConfig = ''
                default_type text/plain;
                add_header Cache-Control "no-store" always;
              ''
              + ssh2rceHeaders
              + ''
                return 200 "ip=$remote_addr\n";
              '';
            };
            # Assets are not fingerprinted, so keep the cache short.
            "~* \\.(css|js|svg|png|txt|xml)$" = {
              extraConfig = ''
                add_header Cache-Control "public, max-age=3600" always;
              ''
              + ssh2rceHeaders;
            };
            "/" = {
              extraConfig = ''
                add_header Cache-Control "no-cache" always;
              ''
              + ssh2rceHeaders;
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
