{ config, lib, ... }:
{
  # This is a PERFORMANCE PROFILE module - optional server tuning for high-traffic workloads.
  # Enable with: snowflake.profile.server-performance.enable = true
  #
  # Use this for servers handling many concurrent connections (web servers, proxies).
  # VPS or low-traffic servers may not need these settings.
  #
  # Settings focus on:
  # - Higher network connection limits
  # - Larger connection tracking tables
  # - Increased network queue sizes

  options.snowflake.profile.server-performance.enable = lib.mkEnableOption "Server performance tuning for high-connection workloads";

  config = lib.mkIf config.snowflake.profile.server-performance.enable {
    boot.kernel.sysctl = {
      # Network tuning for servers with many connections
      "net.core.somaxconn" = 4096;
      "net.ipv4.tcp_max_syn_backlog" = 4096;
      "net.core.netdev_max_backlog" = 5000;

      # Higher connection tracking for web servers
      "net.netfilter.nf_conntrack_max" = 524288;
    };
  };
}
