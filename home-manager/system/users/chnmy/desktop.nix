{pkgs, ...}: {
  home.packages = with pkgs; [
    firefox-nightly-bin
  ];
}
