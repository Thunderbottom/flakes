{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.snowflake.core.fish.enable = lib.mkEnableOption "Enable core fish configuration";

  config = lib.mkIf config.snowflake.core.fish.enable {
    environment.systemPackages = [ pkgs.starship ];
    programs.fish.enable = true;

    users.users.${config.snowflake.user.username} = lib.mkIf config.snowflake.user.enable {
      shell = pkgs.fish;
    };

    users.users.root.shell = pkgs.fish;
  };
}
