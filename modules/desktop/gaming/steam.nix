{
  flake.modules.nixos.steam =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = {
        programs.steam = {
          enable = true;
          gamescopeSession.enable = true;
          remotePlay.openFirewall = true;
          dedicatedServer.openFirewall = true;
          localNetworkGameTransfers.openFirewall = true;
          extraCompatPackages = [ pkgs.proton-ge-bin ];
        };
      };
    };
}
