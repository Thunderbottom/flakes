{
  config,
  lib,
  ...
}:
{
  options.snowflake.core.sshd = {
    enable = lib.mkEnableOption "Enable core sshd configuration";
  };

  config = lib.mkIf config.snowflake.core.sshd.enable {
    services.openssh = {
      enable = true;
      settings = {
        # Disable password auth and root login.
        PasswordAuthentication = false;
        PermitRootLogin = "no";
        KbdInteractiveAuthentication = false;
        PermitEmptyPasswords = false;
        Protocol = 2;
        MaxAuthTries = 3;
        ChallengeResponseAuthentication = false;
        AllowTcpForwarding = "yes";
        X11Forwarding = false;
      };
      openFirewall = true;
    };

    # Enable mosh for access over spotty networks.
    programs.mosh.enable = true;
    programs.ssh.startAgent = !config.services.gnome.gcr-ssh-agent.enable;
  };
}
