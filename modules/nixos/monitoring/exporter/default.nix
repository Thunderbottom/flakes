{
  config,
  lib,
  ...
}: {
  options.snowflake.monitoring.exporter = {
    collectd.enable = lib.mkEnableOption "Enable collectd exporter service";
    node.enable = lib.mkEnableOption "Enable node-exporter service";
    systemd.enable = lib.mkEnableOption "Enable systemd exporter service";
  };

  config = let
    cfg = config.snowflake.monitoring.exporter;
  in {
    services.prometheus.exporters = {
      collectd.enable = cfg.collectd.enable;
      node.enable = cfg.node.enable;
      systemd.enable = cfg.systemd.enable;
      # NOTE: These are the base monitoring modules meant to
      # be enabled by default as sane defaults.
      # Extra options for the defined exporters or custom exporters
      # can be added to machine configuration manually.
      # For example:
      #   services.prometheus.exporters.unifi = {
      #     enable = true;
      #     unifiUsername = "username";
      #     unifiPassword = "password";
      #     unifiInsecure = true;
      #   };
      # This can then be added to the vmagent configuration as extraConfig.
    };
  };
}
