{
  flake.modules.nixos.user =
    {
      config,
      inputs,
      self,
      pkgs,
      ...
    }:
    let
      user = config.profile.username;
      secrets = config.profile.secrets.machines.${config.networking.hostName};
    in
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];

      users.mutableUsers = false;

      environment.homeBinInPath = true;

      age.secrets.hashed-user-password.file = secrets.password.file;
      age.secrets.hashed-root-password.file = secrets.root-password.file;

      # NOTE: hashedPasswordFile has an issue. If the auth method is changed from `hashedPassword`
      # to `hashedPasswordFile`, /etc/shadow gets messed up and login does not work. To fix this
      # we need to remove all the users' entries from /etc/shadow and run nixos-rebuild. Seems to be
      # a one-time thing.
      # ref: https://github.com/NixOS/nixpkgs/issues/99433
      users.users.${user} = {
        description = config.profile.fullName;
        uid = 1000;
        extraGroups = [
          "wheel"
          "users"
        ];
        hashedPasswordFile = config.age.secrets.hashed-user-password.path;
        isNormalUser = true;
      };

      users.users.root.hashedPasswordFile = config.age.secrets.hashed-root-password.path;

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {
          inherit inputs self pkgs;
        };
        sharedModules = [ { inherit (config) profile; } ];
      };
    };
}
