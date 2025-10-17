_: {
  imports = [ ../home.nix ];

  home.stateVersion = "24.05";

  snowflake.desktop = {
    hyprland.enable = true;
    waybar.enable = true;
  };
}
