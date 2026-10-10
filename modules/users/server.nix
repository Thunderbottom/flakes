{ homeManager, ... }:
{
  flake.modules.homeManager.server =
    { lib, ... }:
    {
      imports = with homeManager; [
        base
        atuin
        fish
        helix
        tmux
      ];

      home.stateVersion = lib.mkDefault "24.05";
    };
}
