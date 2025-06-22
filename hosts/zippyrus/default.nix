{
  config,
  inputs,
  pkgs,
  userdata,
  ...
}:
{
  hardware = {
    # Update the CPU microcode for AMD processors.
    cpu.amd.updateMicrocode = true;
    # Enable firmware with a license allowing redistribution.
    enableRedistributableFirmware = true;
    # Enable orientation and ambient light sensor.
    sensor.iio.enable = true;
  };

  age.secrets.network-manager-psk = {
    inherit (userdata.secrets.network-manager.passphrase) file;
    owner = "root";
    group = "root";
  };

  networking = {
    # Improve wireless roaming stability.
    wireless.iwd.settings = {
      General = {
        RoamThreshold = -75;
        RoamThreshold5G = -80;
        RoamRetryInterval = 20;
      };
    };
  };

  services = {
    # Enable G502 mouse configuration daemon.
    ratbagd.enable = true;
  };

  snowflake = {
    extraPackages =
      with pkgs;
      [
        obsidian
        piper
      ]
      ++ [
        inputs.zed.packages.${pkgs.system}.default
      ];

    core = {
      # Enable secure boot.
      lanzaboote.enable = true;
      # Enable docker, use `btrfs` storage driver.
      docker = {
        enable = true;
        storageDriver = "btrfs";
      };
      # `sysctl` configuration for gaming improvements.
      security.sysctl.gaming.enable = true;
      # security.sysctl.performance.enable = true;
    };

    desktop = {
      # Enable desktop-specific defaults.
      enable = true;
      # Enable GNOME desktop environment.
      gnome.enable = true;
    };

    gaming = {
      # Enable proton and steam.
      proton.enable = true;
      steam.enable = true;
    };

    hardware = {
      bluetooth.enable = true;
      yubico.enable = true;
      graphics = {
        amd.enable = true;
        nvidia = {
          enable = true;
          busIDs = {
            amd = "PCI:101:0:0";
            nvidia = "PCI:1:0:0";
          };
        };
      };
    };

    networking = {
      iwd.enable = true;

      wifiProfiles = {
        enable = true;
        environmentFiles = [ config.age.secrets.network-manager-psk.path ];
        networks = {
          "The Y-Fi" = "$THE_YFI_PSK";
          "The Y-Fi 2.4" = "$THE_YFI_PSK";
          "The Y-Fi Inside" = "$THE_YFI_PSK";
        };
      };
    };

    services.asus.enable = true;

    user = {
      enable = true;
      username = "chnmy";
      description = "Chinmay D. Pai";
      extraGroups = [ "video" ];
      userPasswordAgeModule = userdata.secrets.machines.zippyrus.password;
      rootPasswordAgeModule = userdata.secrets.machines.zippyrus.root-password;
    };
  };
}
