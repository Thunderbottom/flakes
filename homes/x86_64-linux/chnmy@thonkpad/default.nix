{
  config,
  pkgs,
  ...
}: {
  snowfallorg.user.enable = true;
  snowfallorg.user.name = "chnmy";

  snowflake.desktop.wezterm.enable = true;
  snowflake.desktop.firefox.enable = true;

  snowflake.development.git.enable = true;
  snowflake.development.git.user = {
    name = "Chinmay D. Pai";
    email = "chinmaydpai@gmail.com";
    signingKey = "75507BE256F40CED";
  };
  snowflake.development.git.work = {
    enable = true;
    email = "chinmay.pai@zerodha.com";
    path = "/home/${config.snowfallorg.user.name}/Documents/Repositories/gitlab.zerodha.tech";
    extraConfig = {
      url."ssh://git@gitlab.zerodha.tech:2280".insteadOf = "https://gitlab.zerodha.tech";
      url."ssh://git@gitlab.zerodha.tech:2280/".insteadOf = "git@gitlab.zerodha.tech:";
    };
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
