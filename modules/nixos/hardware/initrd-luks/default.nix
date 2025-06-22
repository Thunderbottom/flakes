{
  config,
  lib,
  ...
}:
{
  options.snowflake.hardware.initrd-luks = {
    enable = lib.mkEnableOption "Enable initrd-luks hardware configuration";

    sshPort = lib.mkOption {
      type = lib.types.int;
      default = 22;
      description = "SSH Port to use for initrd-luks decryption";
    };
    shell = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Shell to use for initrd-luks decryption";
    };
    hostKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "/etc/ssh/ssh_host_ed25519_key" ];
      description = "Path to the host keys to use for initrd-luks decryption";
    };
    authorizedKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of authorized keys for initrd-luks decyption";
    };
    availableKernelModules = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of available kernel modules for initrd-luks decryption";
    };
  };

  config = lib.mkIf config.snowflake.hardware.initrd-luks.enable {
    # Enable remote LUKS unlocking.
    # This allows remote SSH to unlock LUKS encrypted root.
    # $ ssh root@<ip>
    # While in the shell, run `systemctl default` or `systemd-ask-password`
    # to trigger the unlock prompt.
    boot = {
      initrd.network = {
        flushBeforeStage2 = true;
        enable = true;
        ssh = {
          enable = true;
          port = config.snowflake.hardware.initrd-luks.sshPort;
          inherit (config.snowflake.hardware.initrd-luks) hostKeys;
          inherit (config.snowflake.hardware.initrd-luks) authorizedKeys;
        };
      };
      # Required for the network card that
      # requires a kernel module to work.
      initrd.availableKernelModules = config.snowflake.hardware.initrd-luks.availableKernelModules;
      # Use DHCP to figure out the IP address.
      kernelParams = [ "ip=dhcp" ];
    };
  };
}
