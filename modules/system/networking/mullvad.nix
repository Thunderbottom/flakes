{
  flake.modules.nixos.mullvad =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = {
        networking = {
          # ref: https://github.com/NixOS/nixpkgs/issues/113589
          firewall.checkReversePath = "loose";
          wireguard.enable = true;

          # mullvad-daemon requires iproute2 route tables.
          iproute2.enable = true;
        };

        services.mullvad-vpn = {
          enable = true;
          gui.enable = true;
        };
      };
    };
}
