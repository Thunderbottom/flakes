{ userdata, ... }:
{
  snowflake.development.helix.enable = true;
  snowflake.development.tmux.enable = true;
  snowflake.shell.fish.enable = true;
  snowflake.shell.atuin = {
    enable = true;
    sync.address = "https://atuin.${userdata.domain}";
  };
}
