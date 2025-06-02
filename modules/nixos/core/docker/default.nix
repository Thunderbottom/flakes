{
  config,
  lib,
  namespace,
  ...
}:
{
  options.${namespace}.core.docker = {
    enable = lib.mkEnableOption "Enable core docker configuration";
    enableOnBoot = lib.mkEnableOption "Enable docker on boot";
    storageDriver = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Storage driver backend to use for docker";
    };
  };

  config = lib.mkIf config.${namespace}.core.docker.enable {
    virtualisation.docker = {
      enable = true;
      # Required for containers with `--restart=always`.
      enableOnBoot = config.${namespace}.core.docker.enableOnBoot;
      autoPrune = {
        enable = true;
      };
      inherit (config.${namespace}.core.docker) storageDriver;
    };

    # Add the system user to the docker group
    ${namespace}.user.extraGroups = [ "docker" ];
  };
}
