{
  config,
  lib,
  pkgs,
  ...
}: {
  options.snowflake.services.jellyfin = {
    enable = lib.mkEnableOption "Enable jellyfin deployment configuration";
  };

  config = let
    cfg = config.snowflake.services.jellyfin;
  in
    lib.mkIf cfg.enable {
      services.jellyfin = {
        enable = true;
        openFirewall = true;
      };

      users.groups.media = {
        members = ["@wheel" "jellyfin"];
      };

      nixpkgs.config.packageOverrides = pkgs: {
        jellyfin-ffmpeg = pkgs.jellyfin-ffmpeg.override {
          ffmpeg_6-full = pkgs.ffmpeg_6-full.override {
            withMfx = false;
            withVpl = true;
          };
        };
        vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true;};
      };

      environment.systemPackages = with pkgs; [
        jellyfin-ffmpeg
      ];

      hardware.graphics = {
        enable = true;
        extraPackages = with pkgs; [
          intel-media-driver
          intel-compute-runtime
          vpl-gpu-rt
          vaapiIntel
          vaapiVdpau
          libvdpau-va-gl
        ];
      };

      services.jellyseerr.enable = true;
      services.jellyseerr.openFirewall = true;

      services.nginx = {
        virtualHosts = {
          "jelly.deku.moe" = {
            serverName = "jelly.deku.moe";
            enableACME = true;
            forceSSL = true;
            locations."/" = {
              proxyPass = "http://localhost:8096/";
            };
          };
        };
      };
    };
}
