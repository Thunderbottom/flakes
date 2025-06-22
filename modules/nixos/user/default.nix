{
  config,
  lib,
  inputs,
  self,
  pkgs,
  ...
}:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.snowflake.user = {
    enable = lib.mkEnableOption "Enable user configuration";

    uid = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = 1000;
      description = "User ID for the system user";
    };
    username = lib.mkOption {
      type = lib.types.str;
      description = "Username for the system user";
    };
    description = lib.mkOption {
      type = lib.types.str;
      description = "Real name for the system user";
    };
    extraGroups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
    extraAuthorizedKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Additional authorized keys for the system user";
    };
    extraRootAuthorizedKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Additional authorized keys for root user";
    };
    userPasswordAgeModule = lib.mkOption {
      type = lib.types.attrs;
      description = "Age file to include to use as user password";
    };
    rootPasswordAgeModule = lib.mkOption {
      type = lib.types.attrs;
      description = "Age file to include to use as root password";
    };
    setEmptyPassword = lib.mkEnableOption "Enable to set empty password for the system user";
    setEmptyRootPassword = lib.mkEnableOption "Enable to set empty password for the root user";
  };

  config = {
    # Make users immutable.
    users.mutableUsers = false;

    # Add ~/bin to $PATH.
    environment.homeBinInPath = config.snowflake.user.enable;

    # Load password files.
    age.secrets.hashed-user-password = lib.mkIf (
      !config.snowflake.user.setEmptyPassword && config.snowflake.user.enable
    ) config.snowflake.user.userPasswordAgeModule;
    age.secrets.hashed-root-password = lib.mkIf (
      !config.snowflake.user.setEmptyRootPassword && config.snowflake.user.enable
    ) config.snowflake.user.rootPasswordAgeModule;

    # Configure the user account.
    # NOTE: hashedPasswordFile has an issue. If the auth method is changed from `hashedPassword`
    # to `hashedPasswordFile`, /etc/shadow gets messed up and login does not work. To fix this
    # we need to remove all the users' entries from /etc/shadow and run nixos-rebuild. Seems to be
    # a one-time thing.
    # ref: https://github.com/NixOS/nixpkgs/issues/99433
    users.users.${config.snowflake.user.username} = lib.mkIf config.snowflake.user.enable {
      inherit (config.snowflake.user) description;
      extraGroups = [
        "wheel"
        "users"
      ] ++ config.snowflake.user.extraGroups;
      hashedPasswordFile = lib.mkIf (
        !config.snowflake.user.setEmptyPassword
      ) config.age.secrets.hashed-user-password.path;
      isNormalUser = true;
      openssh.authorizedKeys.keys = config.snowflake.user.extraAuthorizedKeys;
      inherit (config.snowflake.user) uid;
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {
        inherit inputs self pkgs;
      };
      users.${config.snowflake.user.username}.imports = [
        self.homeModules.default
        "${self}/users/shared.nix"
        "${self}/users/${config.snowflake.user.username}/home.nix"
        "${self}/users/${config.snowflake.user.username}/${config.networking.hostName}/home.nix"
      ];
    };

    # Define password, authorized keys and shell for root user.
    users.users.root = {
      hashedPasswordFile = lib.mkIf (
        !config.snowflake.user.setEmptyRootPassword
      ) config.age.secrets.hashed-root-password.path;
      openssh.authorizedKeys.keys = config.snowflake.user.extraRootAuthorizedKeys;
    };
  };
}
