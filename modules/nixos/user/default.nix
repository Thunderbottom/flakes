{
  config,
  lib,
  namespace,
  ...
}: {
  options.${namespace}.user = {
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
      default = [];
    };
    extraAuthorizedKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Additional authorized keys for the system user";
    };
    extraRootAuthorizedKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Additional authorized keys for root user";
    };
    userPasswordAgeModule = lib.mkOption {
      description = "Age file to include to use as user password";
    };
    rootPasswordAgeModule = lib.mkOption {
      description = "Age file to include to use as root password";
    };
    setEmptyPassword = lib.mkEnableOption "Enable to set empty password for the system user";
    setEmptyRootPassword = lib.mkEnableOption "Enable to set empty password for the root user";
  };

  config = {
    # Make users immutable.
    users.mutableUsers = false;

    # Add ~/bin to $PATH.
    environment.homeBinInPath = config.${namespace}.user.enable;

    # Load password files.
    age.secrets.hashed-user-password =
      lib.mkIf (
        !config.${namespace}.user.setEmptyPassword && config.${namespace}.user.enable
      )
      config.${namespace}.user.userPasswordAgeModule;
    age.secrets.hashed-root-password = lib.mkIf (!config.${namespace}.user.setEmptyRootPassword) config.${namespace}.user.rootPasswordAgeModule;

    # Configure the user account.
    # NOTE: hashedPasswordFile has an issue. If the auth method is changed from `hashedPassword`
    # to `hashedPasswordFile`, /etc/shadow gets messed up and login does not work. To fix this
    # we need to remove all the users' entries from /etc/shadow and run nixos-rebuild. Seems to be
    # a one-time thing.
    # ref: https://github.com/NixOS/nixpkgs/issues/99433
    users.users.${config.${namespace}.user.username} = lib.mkIf config.${namespace}.user.enable {
      inherit (config.${namespace}.user) description;
      extraGroups =
        [
          "wheel"
          "users"
        ]
        ++ config.${namespace}.user.extraGroups;
      hashedPasswordFile = lib.mkIf (!config.${namespace}.user.setEmptyPassword) config.age.secrets.hashed-user-password.path;
      isNormalUser = true;
      openssh.authorizedKeys.keys = config.${namespace}.user.extraAuthorizedKeys;
      inherit (config.${namespace}.user) uid;
    };

    # Define password, authorized keys and shell for root user.
    users.users.root = {
      hashedPasswordFile = lib.mkIf (!config.${namespace}.user.setEmptyRootPassword) config.age.secrets.hashed-root-password.path;
      openssh.authorizedKeys.keys = config.${namespace}.user.extraRootAuthorizedKeys;
    };
  };
}
