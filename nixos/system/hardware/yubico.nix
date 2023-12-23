{pkgs, ...}: {
  security = {
    pam = {
      # Enable FIDO Authentication
      # Ref:
      # - https://nixos.wiki/wiki/Yubikey
      u2f.enable = true;
      services = {
        login.u2fAuth = true;
        sudo.u2fAuth = true;
      };
    };
  };
  services.udev.packages = [pkgs.yubikey-personalization];
}
