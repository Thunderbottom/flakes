{
  lib,
  pkgs,
  ...
}: {
  # Keep only last 10 generations
  boot.loader.systemd-boot.configurationLimit = lib.mkDefault 10;

  environment.systemPackages = with pkgs; [
    agenix
    bottom
    busybox
    curl
    dnsutils
    ethtool
    fd
    git
    gnumake
    nil
    python3
    ripgrep
    tree
    wget
  ];

  # nix-helper configuration
  nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 30d";
    };
  };

  nix = {
    package = pkgs.nixUnstable;
    # run garbage collector daily
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
    settings = {
      auto-optimise-store = true;
      builders-use-substitutes = true;
      experimental-features = ["nix-command" "flakes"];
      sandbox = true;
      trusted-users = ["root" "@wheel"];
    };
  };

  programs = {
    fish.enable = true;
    gnupg.agent.enable = true;
    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    mtr.enable = true;
    nix-ld.enable = true;
  };

  services = {
    # Firmware updates for the system
    fwupd.enable = true;

    # Enable the OpenSSH daemon.
    openssh = {
      enable = true;
      # Disable PasswordAuthentication for Sekurity
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
        X11Forwarding = true;
      };
      openFirewall = true;
    };
  };

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Asia/Kolkata";

  virtualisation.docker = {
    enable = true;
    # Required for containers with `--restart=always`
    enableOnBoot = true;
  };
}
