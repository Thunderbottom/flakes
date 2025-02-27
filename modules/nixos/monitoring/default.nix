{
  config,
  lib,
  namespace,
  ...
}: {
  options.${namespace}.monitoring.enable = lib.mkEnableOption "Enable the base monitoring stack configuration";

  config = lib.mkIf config.${namespace}.monitoring.enable {
    # Enable base monitoring modules.
    ${namespace}.monitoring = {
      victoriametrics.enable = lib.mkDefault true;
      grafana.enable = lib.mkDefault true;
      exporter.collectd.enable = lib.mkDefault true;
      exporter.node.enable = lib.mkDefault true;
      exporter.systemd.enable = lib.mkDefault true;
      # NOTE: Extra modules such as unifi-unpoller can be
      # enabled in the system configuration manually.
      # For example:
      # exporter.unifi = true;
      # Check exporter/default.nix for more details.
    };
  };
}
