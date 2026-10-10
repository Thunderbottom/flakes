{ homeManager, ... }:
{
  flake.modules.homeManager.chnmy =
    { pkgs, ... }:
    {
      imports = with homeManager; [
        base
        atuin
        direnv
        firefox
        fish
        ghostty
        git
        gnome-dconf
        helix
        tmux
      ];

      programs.eza.git = true;

      home.packages = [ pkgs.mpv ];
      home.stateVersion = "24.05";
    };
}
