{
  flake.modules.nixos.asus =
    {
      config,
      lib,
      ...
    }:
    {
      config = {
        boot.kernelModules = [
          "asus-nb-wmi"
          "asus-armoury"
        ];

        # specific to Asus laptop
        # source: https://asus-linux.org/guides/nixos/
        services = {
          asusd.enable = true;
          cardwired.enable = true;
          scx = {
            enable = true;
            scheduler = "scx_lavd";
          };
        };

        services.udev.extraRules = ''
          # Disable wakeup on the ASUS ITE device (0b05:193b) to prevent
          # immediate resume after suspend.
          ACTION=="add|change", SUBSYSTEM=="usb", ATTR{idVendor}=="0b05", ATTR{idProduct}=="193b", ATTR{power/wakeup}="disabled"
        '';
      };
    };
}
