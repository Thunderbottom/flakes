{
  config,
  lib,
  ...
}: {
  options.snowflake.services.bazarr = {
    enable = lib.mkEnableOption "Enable bazarr deployment configuration";
  };

  # NOTE: No good subtitle providers are available right now.
  # There's no need to enable bazarr, private trackers have decent
  # subtitles for releases.
  config = lib.mkIf config.snowflake.services.bazarr.enable {
    services.bazarr.enable = true;
    services.bazarr.group = "media";
    services.bazarr.openFirewall = true;
  };
}
