{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.snowflake.hardware.usbguard = {
    # WARNING: be very careful before turning on usbguard. It'll has the potential
    # to disable your keyboard and render your system useless. To use this
    # module follow the following steps.
    #
    # 1. Enable this module while keeping the service.enable option set to false.
    # This will only install usbguard onto your system without enabling the
    # usbguard systemd service.
    # 2. Do not connect any USB devices to your laptop. Or only connect
    # trusted, frequently used devices
    # 3. use the command `usbguard generate-policy` to generate the usbguard
    # "rules". This will generate a list of devices which are trusted and can
    # be interfaced with the system without explicit approval. This include
    # your inbuilt keyboard, webcam etc
    # 4. set the output of this command as the value for the "rules" option,
    # and set the "service.enable" option to true
    #
    # Ref:
    # - https://github.com/USBGuard/usbguard/blob/main/doc/man/usbguard-rules.conf.5.adoc

    # FAQ
    # - to connect a new USB device
    #   - run `sudo usbguard watch` in a tty
    #   - connect your device
    #   - find the device ID from the tty running `usbguard watch`
    #   - run `sudo usbguard allow-device {device_id}`  to allow the device to
    #   interface with the system

    enable = lib.mkEnableOption "Enable usbguard module, only installs the package";

    service.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the usbguard service";
    };

    rules = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Usbguard rules for default devices which are allowed to be connected";
    };
  };

  config = lib.mkIf config.snowflake.hardware.usbguard.enable {
    environment.systemPackages = [ pkgs.usbguard ];

    services.usbguard = {
      inherit (config.snowflake.hardware.usbguard.service) enable;
      inherit (config.snowflake.hardware.usbguard) rules;
      dbus.enable = true;
      IPCAllowedGroups = [ "wheel" ];
    };
  };
}
