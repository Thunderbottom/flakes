{
  config,
  lib,
  namespace,
  ...
}:
{
  options.${namespace}.core.security = {
    enable = lib.mkEnableOption "Enable core security configuration";
    sysctl.enable = lib.mkEnableOption "Enable sysctl security configuration";
    sysctl.gaming.enable = lib.mkEnableOption "Enable sysctl gaming configuration";
  };

  config = lib.mkIf config.${namespace}.core.security.enable {
    boot = lib.mkMerge [
      {
        # Disable console logging.
        consoleLogLevel = 0;

        # Disable verbose message on initrd to prevent log flooding.
        initrd.verbose = false;

        # Use tmpfs for /tmp, and clean only when not using tmpfs.
        tmp.useTmpfs = lib.mkDefault true;
        tmp.tmpfsSize = "95%";

        # Disable kernel param editing on boot.
        loader.systemd-boot.editor = false;
        kernelModules = [ "tcp_bbr" ];
      }

      (lib.mkIf config.${namespace}.core.security.sysctl.enable {
        kernel.sysctl = {
          # The Magic SysRq key is a key combo that allows users connected to the
          # system console of a Linux kernel to perform some low-level commands.
          # Disable it, since we don't need it, and is a potential security concern.
          "kernel.sysrq" = 0;

          ## TCP hardening
          # Prevent bogus ICMP errors from filling up logs.
          "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
          # Reverse path filtering causes the kernel to do source validation of
          # packets received from all interfaces. This can mitigate IP spoofing.
          "net.ipv4.conf.default.rp_filter" = 1;
          "net.ipv4.conf.all.rp_filter" = 1;
          # Do not accept IP source route packets (we're not a router).
          "net.ipv4.conf.all.accept_source_route" = 0;
          "net.ipv6.conf.all.accept_source_route" = 0;
          # Don't send ICMP redirects (again, we're on a router).
          "net.ipv4.conf.all.send_redirects" = 0;
          "net.ipv4.conf.default.send_redirects" = 0;
          # Refuse ICMP redirects (MITM mitigations).
          "net.ipv4.conf.all.accept_redirects" = 0;
          "net.ipv4.conf.default.accept_redirects" = 0;
          "net.ipv4.conf.all.secure_redirects" = 0;
          "net.ipv4.conf.default.secure_redirects" = 0;
          "net.ipv6.conf.all.accept_redirects" = 0;
          "net.ipv6.conf.default.accept_redirects" = 0;
          # Protects against SYN flood attacks.
          "net.ipv4.tcp_syncookies" = 1;
          # Incomplete protection again TIME-WAIT assassination.
          "net.ipv4.tcp_rfc1337" = 1;

          # TCP optimization
          # Enable TCP Fast Open for incoming and outgoing connections.
          "net.ipv4.tcp_fastopen" = 3;
          # Bufferbloat mitigations + slight improvement in throughput & latency.
          "net.ipv4.tcp_congestion_control" = "bbr";
          "net.core.default_qdisc" = "cake";
        };
      })

      (lib.mkIf config.${namespace}.core.security.sysctl.gaming.enable {
        kernel.sysctl = {
          # Better memory management for gaming
          "vm.swappiness" = 10;
          "vm.vfs_cache_pressure" = 50;
          "vm.dirty_ratio" = 15;
          "vm.dirty_background_ratio" = 5;

          # Network performance for gaming
          "net.core.rmem_max" = 16777216;
          "net.core.wmem_max" = 16777216;
          "net.ipv4.tcp_rmem" = "4096 65536 16777216";
          "net.ipv4.tcp_wmem" = "4096 65536 16777216";
        };
      })
    ];

    security = {
      # Prevent replacing the kernel without reboot.
      # protectKernelImage = true;
      # Accept ACME terms, so we don't have to do this later.
      acme.acceptTerms = true;
      # Allows unauthorized applications to send unauthorization request.
      polkit.enable = true;
      # Enable sudo.
      sudo.enable = true;
    };
  };
}
