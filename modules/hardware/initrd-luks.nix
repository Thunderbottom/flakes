{
  flake.modules.nixos.initrd-luks =
    {
      config,
      lib,
      ...
    }:
    {
      config = {
        # Enable remote LUKS unlocking.
        # This allows remote SSH to unlock LUKS encrypted root.
        # $ ssh root@<ip>
        # While in the shell, run `systemctl default` or `systemd-ask-password`
        # to trigger the unlock prompt.
        boot.initrd = {
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
              timeout = 60; # Wait up to 60 seconds for DHCP
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
              port = 22;
              hostKeys = [ "/etc/ssh/ssh_host_ed25519_key" ];
            };
          };
        };

        # Use DHCP kernel parameter only for scripted initrd (systemd ignores it)
        boot.kernelParams = lib.mkIf (!config.boot.initrd.systemd.enable) [ "ip=dhcp" ];
      };
    };
}
