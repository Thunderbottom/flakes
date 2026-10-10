{
  flake.modules.nixos.docker =
    {
      config,
      lib,
      ...
    }:
    {
      config = {
        virtualisation.docker = {
          enable = true;
          autoPrune = {
            enable = true;
          };
          storageDriver = "btrfs";
        };

        users.users.${config.profile.username}.extraGroups = [ "docker" ];
      };
    };
}
