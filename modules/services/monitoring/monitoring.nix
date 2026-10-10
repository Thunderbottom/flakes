{ nixos, ... }:
{
  flake.modules.nixos.monitoring = {
    imports = [
      nixos.victoriametrics
      nixos.grafana
    ];

    services.prometheus.exporters = {
      collectd.enable = true;
      node.enable = true;
      systemd.enable = true;
    };
  };
}
