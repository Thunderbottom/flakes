{
  pkgs,
  specialArgs,
  username,
  ...
}: {
  nix.settings.trusted-users = [username];

  users = {
    mutableUsers = false;
    users = {
      "${username}" = {
        hashedPassword = "${specialArgs.passwdHash}";
        isNormalUser = true;
        shell = pkgs.fish;
        extraGroups = ["docker" "networkmanager" "wheel"]; # Enable ‘sudo’ for the user.
        openssh.authorizedKeys.keys = specialArgs.sshKeys;
      };
    };
  };
}
