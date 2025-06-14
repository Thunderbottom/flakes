{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
{
  options.${namespace}.networking.mullvad.enable = lib.mkEnableOption "Enable Mullvad VPN client";

  config = lib.mkIf config.${namespace}.networking.mullvad.enable {
    networking = {
      # ref: https://github.com/NixOS/nixpkgs/issues/113589
      firewall.checkReversePath = "loose";
      wireguard.enable = true;

      # mullvad-daemon requires iproute2 route tables.
      iproute2.enable = true;
    };

    services.mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };
  };
}
