{ nixos, ... }:
{
  flake.modules.nixos.proton =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [ nixos.steam ];

      config = {
        programs.gamemode.enable = true;

        environment.systemPackages = with pkgs; [
          bottles
          heroic
          mangohud
        ];
        users.users.${config.profile.username}.extraGroups = [ "gamemode" ];
      };
    };
}
