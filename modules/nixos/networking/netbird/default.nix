{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: {
  options.${namespace}.networking.netbird.enable = lib.mkEnableOption "Enable Netbird VPN client";

  config = lib.mkIf config.${namespace}.networking.netbird.enable {
    networking = {
      firewall = {
        checkReversePath = "loose";
        trustedInterfaces = ["wt0"];
        allowedUDPPorts = [config.services.netbird.clients.default.port];
      };
      # networkmanager.unmanaged = ["wt0"];

      # ref: https://github.com/NixOS/nixpkgs/issues/113589
      wireguard.enable = true;
    };

    services.netbird.enable = true;
    # Unmanage the `wt0` interface rules to allow reconnection after suspend.
    systemd.network.config.networkConfig.ManageForeignRoutingPolicyRules = lib.mkDefault false;
    ${namespace}.extraPackages = [pkgs.netbird-ui];
  };
}
