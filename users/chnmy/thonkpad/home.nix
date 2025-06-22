_: {
  imports = [ ../home.nix ];

  snowflake.development.git.work = {
    enable = true;
    email = "chinmay.pai@zerodha.com";
    path = "/home/chnmy/Documents/Repositories/gitlab.zerodha.tech";
    extraConfig = {
      url."ssh://git@gitlab.zerodha.tech:2280".insteadOf = "https://gitlab.zerodha.tech";
      url."ssh://git@gitlab.zerodha.tech:2280/".insteadOf = "git@gitlab.zerodha.tech:";
    };
  };

  home.stateVersion = "24.05";
}
