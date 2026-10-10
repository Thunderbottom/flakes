{
  flake.modules.homeManager.waybar =
    {
      config,
      lib,
      ...
    }:
    {
      config = {
        programs.waybar = {
          enable = true;
          settings = import ./_config.nix;
          style = import ./_style.nix;
        };
      };
    };
}
