{
  config,
  lib,
  ...
}:
{
  options.snowflake.services.asus.enable = lib.mkEnableOption "Enable Asus-specific configuration";

  config = lib.mkIf config.snowflake.services.asus.enable {
    boot.kernelModules = [
      "asus-nb-wmi"
      "asus-armoury"
    ];

    programs.rog-control-center = {
      enable = true;
      autoStart = true;
    };
    # specific to Asus laptop
    # already included in flake.nix from https://github.com/NixOS/nixos-hardware/blob/master/asus/zephyrus/ga402x/shared.nix still overwiting it
    # source: https://asus-linux.org/guides/nixos/
    services = {
      scx = {
        enable = true;
        scheduler = "scx_lavd";
      };
      supergfxd = {
        enable = true;
        settings.mode = "Hybrid";
      };
      asusd.enable = true;
    };

    services.udev.extraRules = ''
      # Disable wakeup on the ASUS ITE device (0b05:193b) to prevent
      # immediate resume after suspend.
      ACTION=="add|change", SUBSYSTEM=="usb", ATTR{idVendor}=="0b05", ATTR{idProduct}=="193b", ATTR{power/wakeup}="disabled"
    '';
  };
}
