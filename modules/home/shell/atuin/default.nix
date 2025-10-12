{
  config,
  lib,
  ...
}:
{
  options.snowflake.shell.atuin = {
    enable = lib.mkEnableOption "Enable atuin shell home configuration";
    sync = {
      address = lib.mkOption {
        type = lib.types.str;
        description = "Host for the atuin sync server";
      };
      frequency = lib.mkOption {
        type = lib.types.str;
        description = "Sync frequency with the atuin sync server";
        default = "15m";
      };
    };
  };

  config = lib.mkIf config.snowflake.shell.atuin.enable {
    programs.atuin = {
      enable = true;
      settings = {
        sync_address = config.snowflake.shell.atuin.sync.address;
        sync_frequency = config.snowflake.shell.atuin.sync.frequency;
        dialect = "uk";
      };
      enableFishIntegration = config.snowflake.shell.fish.enable;
      flags = [ "--disable-up-arrow" ];
    };
  };
}
