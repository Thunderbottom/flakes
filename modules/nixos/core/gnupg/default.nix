{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.snowflake.core.gnupg.enable = lib.mkEnableOption "Enable core gnupg configuration";

  config = lib.mkIf config.snowflake.core.gnupg.enable {
    services.pcscd.enable = true;

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = !config.snowflake.core.sshd.enable;
    };

    environment.systemPackages = [ pkgs.gnupg ];
  };
}
