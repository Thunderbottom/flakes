{
  config,
  lib,
  ...
}: {
  options.snowflake.shell.direnv.enable = lib.mkEnableOption "Enable direnv home configuration";

  config = lib.mkIf config.snowflake.shell.direnv.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
