{
  flake.modules.homeManager.direnv =
    {
      config,
      lib,
      ...
    }:
    {
      config = {
        programs.direnv = {
          enable = true;
          nix-direnv.enable = true;
        };
      };
    };
}
