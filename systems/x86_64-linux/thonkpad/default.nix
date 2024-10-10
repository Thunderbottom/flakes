{
  lib,
  pkgs,
  userdata,
  ...
}: {
  imports = [./hardware.nix];

  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;

  networking.hostName = "thonkpad";
  networking.interfaces.wlan0.useDHCP = lib.mkDefault false;
  networking.useNetworkd = true;

  # Enable weekly btrfs auto-scrub.
  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = ["/"];
  };

  # Power management, enable powertop and thermald.
  powerManagement.powertop.enable = true;
  services.thermald.enable = true;

  # TODO: remove, temporary for mongoDB build
  systemd.services.nix-daemon.environment.TMPDIR = "/var/tmp/nix-daemon";

  services.ratbagd.enable = true;

  snowflake = {
    stateVersion = "24.05";
    extraPackages = with pkgs; [
      easyeffects
      glibc
      obsidian
      piper
      # terraform
      terraform-ls
    ];

    core.lanzaboote.enable = true;

    core.docker.enable = true;
    core.docker.storageDriver = "btrfs";

    desktop.enable = true;
    desktop.fingerprint.enable = true;
    desktop.kde.enable = true;

    gaming.steam.enable = true;

    hardware.bluetooth.enable = true;
    hardware.yubico.enable = true;

    hardware.usbguard = {
      enable = true;
      service.enable = true;
      rules = ''
        allow id 1d6b:0002 serial "0000:00:0d.0" name "xHCI Host Controller" hash "d3YN7OD60Ggqc9hClW0/al6tlFEshidDnQKzZRRk410=" parent-hash "Y1kBdG1uWQr5CjULQs7uh2F6pHgFb6VDHcWLk83v+tE=" with-interface 09:00:00 with-connect-type ""
        allow id 1d6b:0003 serial "0000:00:0d.0" name "xHCI Host Controller" hash "4Q3Ski/Lqi8RbTFr10zFlIpagY9AKVMszyzBQJVKE+c=" parent-hash "Y1kBdG1uWQr5CjULQs7uh2F6pHgFb6VDHcWLk83v+tE=" with-interface 09:00:00 with-connect-type ""
        allow id 1d6b:0002 serial "0000:00:14.0" name "xHCI Host Controller" hash "jEP/6WzviqdJ5VSeTUY8PatCNBKeaREvo2OqdplND/o=" parent-hash "rV9bfLq7c2eA4tYjVjwO4bxhm+y6GgZpl9J60L0fBkY=" with-interface 09:00:00 with-connect-type ""
        allow id 1d6b:0003 serial "0000:00:14.0" name "xHCI Host Controller" hash "prM+Jby/bFHCn2lNjQdAMbgc6tse3xVx+hZwjOPHSdQ=" parent-hash "rV9bfLq7c2eA4tYjVjwO4bxhm+y6GgZpl9J60L0fBkY=" with-interface 09:00:00 with-connect-type ""
        allow id 0bda:0411 serial "" name "USB3.2 Hub" hash "WfY2L4vTgeqoijkio8APWsywYF88RGioDTmQYgrwFWQ=" parent-hash "4Q3Ski/Lqi8RbTFr10zFlIpagY9AKVMszyzBQJVKE+c=" via-port "2-1" with-interface 09:00:00 with-connect-type "hotplug"
        allow id 0bda:5411 serial "" name "USB2.1 Hub" hash "3L4WgoHAw84HzheIfj3futScEN4fKgpTxcy8/f/7LZc=" parent-hash "jEP/6WzviqdJ5VSeTUY8PatCNBKeaREvo2OqdplND/o=" via-port "3-3" with-interface { 09:00:01 09:00:02 } with-connect-type "hotplug"
        allow id 06cb:0123 serial "a791cab37011" name "" hash "sw4ze+9ZwZmVtduvB8usJ46HkIEiAeSjaLpbcQF8Jvs=" parent-hash "jEP/6WzviqdJ5VSeTUY8PatCNBKeaREvo2OqdplND/o=" with-interface ff:00:00 with-connect-type "not used"
        allow id 04f2:b7e0 serial "0001" name "Integrated Camera" hash "ZYgg5bziBh/fUAZv1fclNEfj+8XRrFavcVHenzbXzdM=" parent-hash "jEP/6WzviqdJ5VSeTUY8PatCNBKeaREvo2OqdplND/o=" with-interface { 0e:01:01 0e:02:01 0e:02:01 0e:02:01 0e:02:01 0e:02:01 0e:02:01 0e:02:01 0e:02:01 0e:01:01 0e:02:01 0e:02:01 0e:02:01 0e:02:01 0e:02:01 0e:02:01 0e:02:01 0e:02:01 fe:01:01 } with-connect-type "not used"
        allow id 8087:0036 serial "" name "" hash "XwbcZSrllifsnXXcFkmww6DJnTpumS/N2rYZllwTvH4=" parent-hash "jEP/6WzviqdJ5VSeTUY8Pat                                                                                                                                CNBKeaREvo2OqdplND/o=" via-port "3-10" with-interface { e0:01:01 e0:01:01 e0:01:01 e0:01:01 e0:01:01 e0:01:01 e0:01:01 e0:01:01 } with-connect-type "not used"
        allow id 0bda:8153 serial "3213000001" name "USB 10/100/1000 LAN" hash "A1AuNE+AAY9gDVu7aI2vdF3SaxGcOfkQGHi9ZXSQ2rY=" parent-hash "WfY2L4vTgeqoijkio8APWsywYF88RGioDTmQYgrwFWQ=" with-interface { ff:ff:00 02:06:00 0a:00:00 0a:00:00 } with-connect-type "unknown"
        allow id 0bda:0411 serial "" name "USB3.2 Hub" hash "WfY2L4vTgeqoijkio8APWsywYF88RGioDTmQYgrwFWQ=" parent-hash "WfY2L4vTgeqoijkio8APWsywYF88RGioDTmQYgrwFWQ=" via-port "2-1.2" with-interface 09:00:00 with-connect-type "unknown"
        allow id 0bda:5411 serial "" name "USB2.1 Hub" hash "3L4WgoHAw84HzheIfj3futScEN4fKgpTxcy8/f/7LZc=" parent-hash "3L4WgoHAw84HzheIfj3futScEN4fKgpTxcy8/f/7LZc=" via-port "3-3.2" with-interface { 09:00:01 09:00:02 } with-connect-type "unknown"
        allow id 0bda:1100 serial "" name "HID Device" hash "5qV38hE0ACWm79QYAOtGSKu9XWKXnOma2l8bhjeTCYU=" parent-hash "3L4WgoHAw84HzheIfj3futScEN4fKgpTxcy8/f/7LZc=" via-port "3-3.5" with-interface 03:00:00 with-connect-type "unknown"
        allow id 046d:c08b serial "126639653638" name "G502 HERO Gaming Mouse" hash "kDBrbfHYxgALCAE/mY1ZXOaFyPa3qL5VowXrI++l7zI=" parent-hash "3L4WgoHAw84HzheIfj3futScEN4fKgpTxcy8/f/7LZc=" with-interface { 03:01:02 03:00:00 } with-connect-type "unknown"
        allow id 05ac:024f serial "" name "Keychron K2" hash "P0EEuXdfPcoHSkHSzrh8ufjXNa6gxX5mRrLbafVqmWE=" parent-hash "3L4WgoHAw84HzheIfj3futScEN4fKgpTxcy8/f/7LZc=" via-port "3-3.2.2" with-interface { 03:01:01 03:01:02 } with-connect-type "unknown"
      '';
    };

    networking.firewall.enable = true;
    networking.networkManager.enable = true;
    networking.iwd.enable = true;
    networking.resolved.enable = true;
    networking.netbird.enable = true;

    user.enable = true;
    user.username = "chnmy";
    user.description = "Chinmay D. Pai";
    user.extraGroups = ["video"];
    user.userPasswordAgeModule = userdata.secrets.machines.thonkpad.password;
    user.rootPasswordAgeModule = userdata.secrets.machines.thonkpad.root-password;
  };
}
