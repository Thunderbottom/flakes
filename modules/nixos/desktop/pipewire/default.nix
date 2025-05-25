{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
{
  options.${namespace}.desktop.pipewire = {
    enable = lib.mkEnableOption "Enable pipewire configuration";
    enableLowLatency = lib.mkEnableOption "Enable low-latency audio (might cause crackling)";
  };

  config = lib.mkIf config.${namespace}.desktop.pipewire.enable {
    # Enable sound.
    # sound.enable = true;

    # Use pipewire for sound and disable pulseaudio.
    services.pulseaudio = {
      enable = false;
      package = pkgs.pulseaudioFull;
    };

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;

      extraConfig.pipewire = lib.mkIf config.${namespace}.desktop.pipewire.enableLowLatency {
        "99-playback-96khz.conf" = {
          "context.properties" = {
            "default.clock.rate" = 48000;
            "default.clock.allowed-rates" = [
              44100
              48000
              88200
              96000
              176400
              192000
            ];
            "default.clock.quantum" = 256;
            "default.clock.min-quantum" = 64;
            "default.clock.max-quantum" = 512;
            "default.clock.quantum-limit" = 8192;
          };
        };
      };
    };
    security.rtkit.enable = true;

    # Add sof-firmware for system mic and speaker mute keys.
    # Specifically for thinkpad, might work for a few other systems (untested).
    environment.systemPackages = [
      pkgs.sof-firmware
      pkgs.ffmpeg
    ];
  };
}
