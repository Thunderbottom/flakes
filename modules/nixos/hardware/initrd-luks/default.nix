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
    boot.initrd = {
      # Required for the network card that requires a kernel module to work.
      inherit (config.snowflake.hardware.initrd-luks) availableKernelModules;

      # Systemd networkd DHCP config (required when systemd is in initrd)
      systemd.network = lib.mkIf config.boot.initrd.systemd.enable {
        networks."10-initrd-wan" = {
          matchConfig.Name = "enp2s0";
          networkConfig.DHCP = "yes";
          dhcpV4Config = {
            ClientIdentifier = "mac";
          };
        };
        # Wait for network to be actually online (DHCP lease acquired) before continuing
        wait-online = {
          enable = true;
          anyInterface = true;
          timeout = 60;  # Wait up to 60 seconds for DHCP
        };
      };

      # Network and SSH config (works with both scripted and systemd initrd)
      network = {
        enable = true;
        flushBeforeStage2 = true;
        # udhcpc only needed for scripted initrd (not systemd)
        udhcpc.enable = lib.mkIf (!config.boot.initrd.systemd.enable) true;
        ssh = {
          enable = true;
          port = config.snowflake.hardware.initrd-luks.sshPort;
          inherit (config.snowflake.hardware.initrd-luks) hostKeys authorizedKeys;
        };
      };
    };

    # Use DHCP kernel parameter only for scripted initrd (systemd ignores it)
    boot.kernelParams = lib.mkIf (!config.boot.initrd.systemd.enable) [ "ip=dhcp" ];
  };
}
