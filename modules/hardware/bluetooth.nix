{
  flake.modules.nixos.bluetooth =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = {
        hardware.bluetooth = {
          enable = true;
          powerOnBoot = false;
          settings = {
            General = {
              Enable = "Source,Sink,Media,Socket";
              # Enable battery charge levels for bluetooth devices.
              Experimental = true;
              KernelExperimental = true;
            };
          };
        };

        # Add support for Bluetooth LE
        environment.systemPackages = [ pkgs.liblc3 ];
      };
    };
}
