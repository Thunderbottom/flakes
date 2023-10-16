{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./core-server.nix
    ../commons
  ];

  environment.shells = with pkgs; [
    bash
    fish
  ];

  environment.systemPackages = with pkgs; [
    devenv
  ];

  programs = {
    adb.enable = true;
    ssh.startAgent = true;
    dconf.enable = true;
  };

  services.udev.packages = with pkgs; [android-udev-rules];
}
