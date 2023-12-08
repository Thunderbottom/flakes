{
  lib,
  pkgs,
  ...
}: {
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
    systemPackages = with pkgs; [
      bottom
      busybox
      curl
      dnsutils
      ethtool
      pciutils
      python3
      unzip
      wget
    ];
  };

  fonts = {
    # Enable a basic set of fonts providing several font styles and families and reasonable coverage of Unicode.
    enableDefaultPackages = false;
    fontDir.enable = true;
    packages = with pkgs; [
      (nerdfonts.override {fonts = ["FiraCode" "JetBrainsMono" "SourceCodePro" "UbuntuMono"];})
      fira
      fira-go
      liberation_ttf
      noto-fonts
      noto-fonts-emoji
      noto-fonts-extra
      source-serif
      ubuntu_font_family
      work-sans
    ];

    fontconfig = {
      antialias = true;
      defaultFonts = {
        serif = ["Noto Serif" "Noto Color Emoji"];
        sansSerif = ["Noto Sans" "Noto Color Emoji"];
        monospace = ["JetBrainsMono Nerd Font" "Noto Color Emoji"];
        emoji = ["Noto Color Emoji"];
      };
      enable = true;
      hinting = {
        autohint = false;
        enable = true;
        style = "slight";
      };
      subpixel = {
        rgba = "rgb";
        lcdfilter = "light";
      };
    };
  };

  programs = {
    fish.enable = true;
    gnupg.agent.enable = true;
    # Some programs need SUID wrappers,
    # can be configured further or is started in user sessions.
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
}
