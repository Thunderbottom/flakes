{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.cleanTmpDir = true;
  boot.consoleLogLevel = 3;
  boot.extraModprobeConfig = ''
    options snd_hda_intel power_save=1
    options i915 enable_rc6=1 enable_fbc=1 fastboot=1 lvds_downclock=1
  '';
  boot.kernelParams = [
    "quiet"
    "intremap=off"
    "elevator=deadline"
  ];

  boot.kernel.sysctl = {
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

  boot.blacklistedKernelModules = [ "uvcvideo" "wl" "bluetooth" "btusb" ];

  # Networking configuration.
  networking.hostName = "tuxbox"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.enableB43Firmware = true;
  networking.extraHosts = ''
    127.0.0.1    tuxbox
  '';
  networking.enableIPv6 = false;
  networking.dhcpcd.persistent = true;
  networking.dhcpcd.extraConfig = ''
    noarp
    ipv4only
    noipv6
  '';


  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Fonts
  fonts.enableFontDir = true;
  fonts.enableCoreFonts = true;
  fonts.enableGhostscriptFonts = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    vim
    git
    acpi
    screen
    zip
    unzip
    which
    file
    ntfs3g
    sshfsFuse
    curl
  ];

  # Allow non-free packages
  nixpkgs.config.allowUnfree = true;
  
  # Enable Thunderbolt module.
  nixpkgs.config.packageOverrides = pkgs: {
    linux = pkgs.linuxPackages.override {
      extraConfig = ''
        THUNDERBOLT m
      '';
    };
  };

  # disable udev-settle
  systemd.services.systemd-udev-settle.enable = false;

  # Enable power management.
  powerManagement.enable = true;
  services.tlp.enable = true;
  services.tlp.extraConfig = ''
    USB_BLACKLIST_PHONE=1
  '';

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.bash.enableCompletion = true;
  programs.bash.shellAliases = {
    vim = "nvim";
  };
  # programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # Disable nscd
  services.nscd.enable = false;

  # Enable upower
  services.upower.enable = true;

  # Enable fstrim.
  services.fstrim.enable = true;

  # Enable openssh daemon.
  services.openssh.enable = true;
  services.openssh.ports = [ 22 ];

  # Enable acpid.
  services.acpid.enable = true;
  services.logind.lidSwitchDocked = "suspend";
  services.logind.extraConfig = ''
    HandlePowerKey=suspend
  '';

  # Enable mbpfan.
  services.mbpfan.enable = true;

  # Enable thermald.
  services.thermald.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable microcode updates.
  hardware.cpu.intel.updateMicrocode = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
  
  # Bluetooth configuration.
  hardware.bluetooth.enable = false;

  # OpenGL VAAPI
  hardware.opengl.extraPackages = [ pkgs.vaapiIntel pkgs.vaapiVdpau ];

  # Enable the X11 windowing system.
  # services.xserver.autorun = false;
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.videoDrivers = [ "intel" ];
  services.xserver.xkbVariant = "mac";
  services.xserver.xkbOptions = "terminate:ctrl_alt_bksp, ctrl:nocaps";

  # Libinput configuration.
  services.xserver.libinput.enable = true;
  services.xserver.libinput.accelSpeed = "0.6";
  services.xserver.libinput.disableWhileTyping = true;
  services.xserver.libinput.naturalScrolling = true;
  services.xserver.libinput.tappingDragLock = false;
  services.xserver.libinput.additionalOptions = ''
    Option "TappingDrag" "off"
  '';

  # Display manager and desktop manager.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.sddm.setupScript = ''
    ${pkgs.xorg.xrandr}/bin/xrandr --output LVDS1 --pos 640x1080 --rotate normal
  '';
  services.xserver.displayManager.sddm.autoLogin = {
    enable = true;
    user = "smolboye";
  };
  services.xserver.windowManager.bspwm.enable = true;
  services.xserver.windowManager.bspwm.configFile = "/etc/nixos/bspwmrc";
  services.xserver.windowManager.bspwm.sxhkd.configFile = "/etc/nixos/sxhkdrc";
  services.xserver.desktopManager.default = "none";
  services.xserver.windowManager.default = "bspwm";
  services.xserver.desktopManager.xterm.enable = false;

  # Monitor configuration
  services.xserver.xrandrHeads = [
    {
      output = "HDMI1";
      monitorConfig = ''
        Modeline "2560x1080_52.00" 196.50 2560 2712 2976 3392 1080 1083 1093 1115 -hsync +vsync
        Option "PreferredMode" "2560x1080_52.00"
      '';
    }
  ];

  # Enable udev rule.
  services.udev.extraRules = ''
    KERNEL=="card0", SUBSYSTEM=="drm", ENV{DISPLAY}=":0", ENV{XAUTHORITY}="/home/smolboye/.Xauthority", RUN+="/etc/nixos/bspwmrc"
  '';

  # Enable sudo.
  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = true;

  # User account configuration.
  users.extraUsers.smolboye = {
    isNormalUser = true;
    uid = 1000;
    group = "users";
    description = "Chinmay Pai";
    extraGroups = [
      "wheel"
      "systemd-journal"
      "audio"
      "video"
    ];
    createHome = true;
    home = "/home/smolboye";
  };

  # Mount filesystems.
  fileSystems."/home/smolboye/hdd" =
  {
    device = "/dev/disk/by-uuid/02b58034-d250-4a2d-b854-484c399c687e";
    fsType = "ext4";
  };

  fileSystems."/home/smolboye/seagate" =
  {
    device = "${pkgs.sshfsFuse}/bin/sshfs#pi@192.168.0.107:/home/pi/seagate";
    fsType = "fuse";
    options = [ "noauto" "_netdev" "x-systemd.automount" "port=22693" "user" "allow_other" 
                "noatime" "follow_symlinks" "IdentityFile=/home/smolboye/.ssh/id_rsa"
                "reconnect" "uid=1000" "gid=1000"
    ];
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.03"; # Did you read the comment?

}
