{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: {
  options.${namespace}.core.gnupg.enable = lib.mkEnableOption "Enable core gnupg configuration";

  config = lib.mkIf config.${namespace}.core.gnupg.enable {
    services.pcscd.enable = true;

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = !config.${namespace}.core.sshd.enable;
    };

    environment.systemPackages = [pkgs.gnupg];
  };
}
