{
  config,
  lib,
  namespace,
  ...
}: {
  options.${namespace}.shell.direnv.enable = lib.mkEnableOption "Enable direnv home configuration";

  config = lib.mkIf config.${namespace}.shell.direnv.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
