{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    
    cleanTmpDir = true;
    consoleLogLevel = 3;
    extraModprobeConfig = ''
      options snd_hda_intel power_save=1
      options i915 semaphores=1 enable_rc6=1 enable_fbc=1 fastboot=1
    '';

    kernelParams = [
      "quiet"
      "intremap=off"
      "elevator=deadline"
    ];

    kernel.sysctl = {
      "vm.swappiness" = 5;
      "vm.vfs_cache_pressure" = 50;
      "vm.dirty_background_ratio" = 25;
      "vm.dirty_background_bytes" = 0;
      "vm.dirty_ratio" = 75;
      "vm.dirty_bytes" = 0;
      "vm.dirty_expire_centisecs" = 6000;
      "vm.dirty_writeback_centisecs" = 2000;
      "ipv6.disable" = 1;
    };

    blacklistedKernelModules = ["uvcvideo" "wl" "bluetooth" "btusb"];
  };

  networking = {
    hostName = "tuxbox";
    networkmanager.enable = true;
    enableB43Firmware = true;
    extraHosts = ''
      127.0.0.1
    '';

    enableIPv6 = false;

    dhcpcd = {
      extraConfig = ''
        noarp
        ipv4only
        noipv6
      '';
    };
  };

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Asia/Kolkata";

  fonts = {
    enableFontDir = true;
    enableCoreFonts = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      anonymousPro
      corefonts
      dejavu_fonts
      font-droid
      freefont_ttf
      google-fonts
      inconsolata
      liberation_ttf
      source-code-pro
      terminus_font
      ttf_bitstream_vera
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    acpi
    curl
    dunst
    file
    git
    ntfs3g
    screen
    sshfsFuse
    termite
    unzip
    vim
    wget
    which
    zip
  ];

  nix.useSandbox = true;

  nixpkgs = {
    config = {
      allowUnfree = true;
      packageOverrides = pkgs: {
        linux = pkgs.linuxPackages.override {
          extraConfig = ''
            THUNDERBOLT m
          '';
        };
      };
    };
  };

  systemd = {
    services.systemd-udev-settle.enable = false;
    user.services."dunst" = {
      enable = true;
      description = "";
      wantedBy = [ "default.target" ];
      serviceConfig = {
        Restart = "always";
        RestartSec = 2;
        ExecStart = "${pkgs.dunst}/bin/dunst";
      };
    };
  };

  programs = {
    bash = {
      enableCompletion = true;
      shellAliases = {
        ls = "ls --color=auto";
        la = "ls -la";
        vim = "nvim";
        weessh = "ssh pi@smolboye.nerdpol.ovh -p11532 -t screen -D -RR weechat weechat";
      };
    };

    gnupg.agent = {
      enable = true; enableSSHSupport = true;
    };

    light.enable = true;
    kbdlight.enable = true;
    adb.enable = true;
  };

  powerManagement.enable = true;

  services = {
    tlp = {
      enable = true;
      extraConfig = ''
        USB_BLACKLIST_PHONE=1
      '';
    };

    nscd.enable = false;
    upower.enable = true;
    fstrim.enable = true;

    openssh = {
      enable = true;
      ports = [ 22 ];
    };

    acpid.enable = true;
    logind = {
      lidSwitchDocked = "suspend";
      extraConfig = ''
        HandlePowerKey=suspend
      '';
    };

    mbpfan.enable = true;
    thermald.enable = true;

    xserver = {
      enable = true;
      layout = "us";
      videoDrivers = [ "intel" ];
      xkbVariant = "mac";
      xkbOptions = "ctrl:nocaps";

      libinput = {
        enable = true;
        accelSpeed = "0.6";
        disableWhileTyping = true;
        naturalScrolling = true;
        tappingDragLock = false;
        additionalOptions = ''
          Option "TappingDrag" "off"
        '';
      };

      displayManager.sddm = {
        enable = true;
        setupScript = ''
          ${pkgs.xorg.xrandr}/bin/xrandr --output LVDS1 --pos 640x1080 --rotate normal
        '';
      };

      windowManager = {
        default = "bspwm";
        bspwm = {
          enable = true;
          configFile = "/etc/nixos/bspwmrc";
          sxhkd.configFile = "/etc/nixos/sxhkdrc";
        };
      };

      desktopManager = {
        default = "none";
        xterm.enable = false;
      };

      xrandrHeads = [
        {
          output = "HDMI1";
          monitorConfig = ''
            Modeline "2560x1080_52.00" 196.50 2560 2712 2976 3392 1080 1083 1093 1115 -hsync +vsync
            Option "PreferredMode" "2560x1080_52.00"
          '';
        }
      ];
    };
      
  };

  sound.enable = true;

  hardware = {
    cpu.intel.updateMicrocode = true;
    
    pulseaudio = {
      enable = true;
      support32Bit = true;
    };

    bluetooth.enable = false;
    opengl.extraPackages = [ pkgs.vaapiIntel pkgs.vaapiVdpau ];
  };

  # Enable udev rule.
  # services.udev.extraRules = ''
  #   KERNEL=="card0", SUBSYSTEM=="drm", ENV{DISPLAY}=":0", ENV{XAUTHORITY}="/home/smolboye/.Xauthority", RUN+="/etc/nixos/bspwmrc"
  # '';

  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;
  };

  users.extraUsers.smolboye = {
    isNormalUser = true;
    uid = 1000;
    group = "users";
    description = "Chinmay Pai";
    extraGroups = [
      "wheel"
      "adbusers"
      "systemd-journal"
      "networkmanager"
      "audio"
      "video"
    ];
    createHome = true;
    home = "/home/smolboye";
  };

  fileSystems = {
    "/home/smolboye/hdd" = {
      device = "/dev/disk/by-uuid/02b58034-d250-4a2d-b854-484c399c687e";
      fsType = "ext4";
    };

    "/home/smolboye/seagate" = {
      device = "${pkgs.sshfsFuse}/bin/sshfs#pi@192.168.0.107:/home/pi/seagate";
      fsType = "fuse";
      options = [ "noauto" "_netdev" "x-systemd.automount" "port=22693" "user" "allow_other" 
                  "noatime" "follow_symlinks" "IdentityFile=/home/smolboye/.ssh/id_rsa"
                  "reconnect" "uid=1000" "gid=1000"
      ];
    };
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.03"; # Did you read the comment?

}
