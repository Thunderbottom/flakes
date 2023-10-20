{pkgs, ...}: {
  services = {
    nomad = {
      enable = true;
      dropPrivileges = false;
      enableDocker = true;
      extraPackages = with pkgs; [cni-plugins];
      package = pkgs.nomad_1_6;
      settings = {
        datacenter = "trench";
        bind_addr = "{{ GetInterfaceIP \"enp6s0\" }}";

        advertise = {
          http = "{{ GetInterfaceIP \"enp6s0\" }}";
          rpc = "{{ GetInterfaceIP \"enp6s0\" }}";
          serf = "{{ GetInterfaceIP \"enp6s0\" }}";
        };

        acl = {
          enabled = true;
        };

        consul = {
          auto_advertise = false;
          server_auto_join = false;
          client_auto_join = false;
        };

        telemetry = {
          collection_interval = "15s";
          disable_hostname = true;
          prometheus_metrics = true;
          publish_allocation_metrics = true;
          publish_node_metrics = true;
        };

        server = {
          enabled = true;
          bootstrap_expect = 1;
          encrypt = "I5aj2gi4NYNvaUWuuaEDQVMtiu6G8PogWw3Oo2TplnI=";
        };

        client = {
          enabled = true;
          cni_path = "${pkgs.cni-plugins}/bin";
        };

        plugin."docker".config = {
          allow_privileged = true;
          volumes = {
            enabled = true;
          };
        };
      };
    };
  };
}
