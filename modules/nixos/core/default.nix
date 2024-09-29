{
  config,
  lib,
  pkgs,
  ...
}: {
  options.snowflake = {
    stateVersion = lib.mkOption {
      type = lib.types.str;
      example = "24.05";
      description = "NixOS state version to use for this system";
    };
    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "Extra packages to be installed system-wide";
    };
    timeZone = lib.mkOption {
      type = lib.types.str;
      description = "Timezone to use for the system";
      default = "Asia/Kolkata";
    };
  };

  config = {
    console = {
      font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
      keyMap = lib.mkDefault "us";
      useXkbConfig = true;
    };

    # Enable all snowflake core modules.
    snowflake.core.fish.enable = lib.mkDefault true;
    snowflake.core.gnupg.enable = lib.mkDefault true;
    snowflake.core.nix.enable = lib.mkDefault true;
    snowflake.core.security.enable = lib.mkDefault true;
    snowflake.core.security.sysctl.enable = lib.mkDefault true;
    snowflake.core.sshd.enable = lib.mkDefault true;

    boot = {
      initrd.systemd.enable = true;
      initrd.verbose = false;
      # Default to the latest kernel package.
      kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
      kernelParams = [
        "nmi_watchdog=0"
      ];

      loader = {
        efi.canTouchEfiVariables = true;
        # Use systemd-boot for all systems.
        systemd-boot = {
          enable = true;
          # Show only last 5 configurations in the boot menu.
          configurationLimit = lib.mkDefault 5;
        };
      };
    };

    # NixOS documentation.
    documentation = {
      enable = true;
      doc.enable = false;
      info.enable = false;
      man.enable = true;
      nixos.enable = false;
    };

    environment = {
      defaultPackages = with pkgs;
        lib.mkForce [
          gitMinimal
          home-manager
          rsync
        ];
      shells = with pkgs; [
        bash
        fish
      ];
      systemPackages = with pkgs;
        [
          bat
          btop
          curl
          duf
          fd
          file
          fzf
          git
          gnumake
          jc
          jq
          ncdu
          ripgrep
          tree
          unzip
          wget

          # Networking tools.
          dnsutils
          ethtool
          host
          prettyping
          whois
        ]
        ++ config.snowflake.extraPackages;
    };

    i18n = {
      defaultLocale = "en_US.UTF-8";
      extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
      };
      supportedLocales = ["en_US.UTF-8/UTF-8"];
    };

    # Can be configured further or is started in user sessions.
    programs.mtr.enable = true;
    # Run unpatched dynamic binaries on NixOS.
    programs.nix-ld.enable = true;

    # Enable firmware updates for the system.
    services.fwupd.enable = true;

    # Enable irqbalance.
    services.irqbalance.enable = true;

    # Use a high-performance implementation for DBus
    services.dbus.implementation = "broker";

    # Workaround for irqbalance read-only filesystem issue.
    # ref: https://github.com/Irqbalance/irqbalance/issues/308
    systemd.services.irqbalance.serviceConfig.ProtectKernelTunables = "no";

    system.stateVersion = config.snowflake.stateVersion;
    system.activationScripts.diff = {
      supportsDryActivation = true;
      text = ''
        ${pkgs.nvd}/bin/nvd --nix-bin-dir=${pkgs.nix}/bin diff /run/current-system "$systemConfig"
      '';
    };

    time.timeZone = config.snowflake.timeZone;

    # Enable zram swap.
    # ref: https://wiki.archlinux.org/title/Zram
    zramSwap.enable = true;
  };
}
