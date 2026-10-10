{ nixos, ... }:
{
  flake.modules.nixos.core =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        nixos.fish
        nixos.gnupg
        nixos.nix
        nixos.security
        nixos.sshd
      ];

      config = {
        hardware.enableRedistributableFirmware = true;

        networking = {
          firewall.enable = true;
          nftables.enable = true;
          useDHCP = false;
        };

        console = {
          font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
          keyMap = lib.mkDefault "us";
          useXkbConfig = true;
        };

        boot = {
          initrd.systemd.enable = lib.mkDefault true;
          kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
          kernelParams = [
            "nmi_watchdog=0"
          ];

          loader = {
            efi.canTouchEfiVariables = true;
            systemd-boot = {
              enable = lib.mkDefault true;
              configurationLimit = lib.mkDefault 5;
            };

            grub = {
              efiSupport = true;
              forceInstall = true;
            };
          };
        };

        documentation = {
          enable = true;
          doc.enable = false;
          info.enable = false;
          man.enable = true;
          nixos.enable = false;
        };

        environment = {
          defaultPackages =
            with pkgs;
            lib.mkForce [
              gitMinimal
              rsync
            ];
          shells = with pkgs; [
            bash
            fish
          ];
          systemPackages = with pkgs; [
            bat
            btop
            curl
            duf
            fd
            file
            git
            gnumake
            jc
            jq
            ncdu
            ripgrep
            tree
            unzip
            wget

            dnsutils
            ethtool
            host
            prettyping
            whois
          ];
        };

        i18n = {
          defaultLocale = config.profile.locale;
          extraLocaleSettings = lib.genAttrs [
            "LC_ADDRESS"
            "LC_IDENTIFICATION"
            "LC_MEASUREMENT"
            "LC_MONETARY"
            "LC_NAME"
            "LC_NUMERIC"
            "LC_PAPER"
            "LC_TELEPHONE"
            "LC_TIME"
          ] (_: config.profile.locale);
          supportedLocales = [ "${config.profile.locale}/UTF-8" ];
        };

        programs.mtr.enable = true;
        programs.nix-ld.enable = true;

        services.fwupd.enable = true;

        services.irqbalance.enable = true;

        services.dbus.implementation = "broker";

        services.fstrim.enable = true;

        services.smartd = {
          enable = true;
          autodetect = true;
          notifications = {
            wall.enable = true;
            mail = { };
          };
        };

        systemd.services.irqbalance.serviceConfig.ProtectKernelTunables = "no";

        services.journald.settings.Journal = {
          SystemMaxUse = "500M";
          SystemMaxFileSize = "50M";
          MaxRetentionSec = "7day";
        };

        system.stateVersion = lib.mkDefault "25.05";
        system.activationScripts.diff = {
          supportsDryActivation = true;
          text = ''
            ${pkgs.nvd}/bin/nvd --nix-bin-dir=${pkgs.nix}/bin diff /run/current-system "$systemConfig"
          '';
        };

        time.timeZone = config.profile.timezone;

        zramSwap = {
          enable = true;
          algorithm = "zstd";
          memoryPercent = 50;
        };
      };
    };
}
