{
  config,
  lib,
  pkgs,
  ...
}: {
  options.snowflake.desktop.pipewire.enable = lib.mkEnableOption "Enable pipewire configuration";

  config = lib.mkIf config.snowflake.desktop.pipewire.enable {
    # Enable sound.
    # sound.enable = true;

    # Use pipewire for sound and disable pulseaudio.
    services.pulseaudio.enable = false;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
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
