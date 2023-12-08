{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    emacsPackages.adwaita-dark-theme
    emacsPackages.vterm

    (aspellWithDicts (ds: with ds; [en en-computers en-science]))
  ];
  services = {
    emacs = {
      enable = true;
      package = pkgs.emacs29-pgtk;
    };
  };
}
