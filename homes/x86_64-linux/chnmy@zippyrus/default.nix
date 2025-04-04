{ pkgs, ... }:
{
  snowfallorg.user.enable = true;
  snowfallorg.user.name = "chnmy";

  snowflake.desktop.firefox.enable = true;
  snowflake.desktop.ghostty.enable = true;
  snowflake.desktop.gnome-dconf.enable = true;

  snowflake.development.git.enable = true;
  snowflake.development.git.user = {
    name = "Chinmay D. Pai";
    email = "chinmaydpai@gmail.com";
    signingKey = "75507BE256F40CED";
  };

  snowflake.development.helix.enable = true;
  snowflake.development.tmux.enable = true;
  snowflake.shell.fish.enable = true;
  snowflake.shell.direnv.enable = true;

  home.packages = [
    pkgs.mpv
  ];

  home.stateVersion = "24.05";
}
