{
  flake.modules.nixos.security =
    {
      config,
      lib,
      ...
    }:
    {
      config = {
        boot = lib.mkMerge [
          {
            consoleLogLevel = 0;

            initrd.verbose = false;

            # Use tmpfs for /tmp, and clean only when not using tmpfs.
            tmp.useTmpfs = lib.mkDefault true;
            tmp.tmpfsSize = "95%";

            loader.systemd-boot.editor = false;
            kernelModules = [ "tcp_bbr" ];
          }

          {
            kernel.sysctl = {
              # Security hardening
              "kernel.sysrq" = 0;
              "kernel.kptr_restrict" = 2;
              "kernel.dmesg_restrict" = 1;
              "kernel.unprivileged_bpf_disabled" = 1;
              "net.core.bpf_jit_harden" = 2;

              # Connection tracking (moderate default for all hosts)
              "net.netfilter.nf_conntrack_max" = 262144;

              ## TCP hardening
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
              "net.ipv6.conf.all.accept_redirects" = 0;
              "net.ipv6.conf.default.accept_redirects" = 0;
              # Incomplete protection again TIME-WAIT assassination.
              "net.ipv4.tcp_rfc1337" = 1;

              # Proven performance optimizations
              # Enable TCP Fast Open for incoming and outgoing connections.
              "net.ipv4.tcp_fastopen" = 3;
              # Bufferbloat mitigations + slight improvement in throughput & latency.
              "net.ipv4.tcp_congestion_control" = "bbr";
              "net.core.default_qdisc" = "cake";
            };
          }
        ];

        security = {
          acme.acceptTerms = true;
          polkit.enable = true;
          sudo.enable = true;
        };
      };
    };
}
