{
  config,
  lib,
  namespace,
  ...
}:
{
  options.${namespace}.services.asus.enable = lib.mkEnableOption "Enable Asus-specific configuration";

  config = lib.mkIf config.${namespace}.services.asus.enable {
    # specific to Asus laptop
    # already included in flake.nix from https://github.com/NixOS/nixos-hardware/blob/master/asus/zephyrus/ga402x/shared.nix still overwiting it
    # source: https://asus-linux.org/guides/nixos/
    services = {
      supergfxd.enable = true;
      asusd = {
        enable = true;
        enableUserService = true;
      };
    };
  };
}
