{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware.nix
    ../../modules/nixos/core-desktop.nix
    ../../modules/nixos/user-group.nix
    ../../modules/gnome
    ../../modules/programs/nixvim
    ../../modules/programs/emacs
  ];

  environment.systemPackages = with pkgs; [
    editorconfig-core-c
    netbird-ui
    pulumi-bin
    terraform
    terraform-ls
  ];

  networking = {
    hostName = "hades";
    # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
    # (the default) this is the recommended approach. When using systemd-networkd it's
    # still possible to use this option, but it's recommended to use it in conjunction
    # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
    useDHCP = lib.mkDefault false;
    interfaces.wlan0.useDHCP = lib.mkDefault false;
    networkmanager = {
      enable = true;
      wifi.backend = "iwd"; # Use iwd instead of wpa_supplicant
    };
    wireless.iwd.enable = true;
    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    firewall.enable = false;
  };

  services = {
    netbird.enable = true;
  };

  system.stateVersion = "23.05";
}
