{
  flake.modules.nixos.usbguard =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = {
        environment.systemPackages = [ pkgs.usbguard ];

        services.usbguard = {
          enable = config.services.usbguard.rules != "";
          dbus.enable = true;
          IPCAllowedGroups = [ "wheel" ];
        };
      };
    };
}
