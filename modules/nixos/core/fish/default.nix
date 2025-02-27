{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: {
  options.${namespace}.core.fish.enable = lib.mkEnableOption "Enable core fish configuration";

  config = lib.mkIf config.${namespace}.core.fish.enable {
    environment.systemPackages = [pkgs.starship];
    programs.fish.enable = true;

    users.users.${config.${namespace}.user.username} = lib.mkIf config.${namespace}.user.enable {
      shell = pkgs.fish;
    };

    users.users.root.shell = pkgs.fish;
  };
}
