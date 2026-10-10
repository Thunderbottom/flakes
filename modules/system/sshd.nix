{
  flake.modules.nixos.sshd =
    {
      config,
      lib,
      ...
    }:
    {
      config = {
        services.openssh = {
          enable = true;
          settings = {
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

        programs.mosh.enable = true;
        programs.ssh.startAgent = !config.services.gnome.gcr-ssh-agent.enable;
      };
    };
}
