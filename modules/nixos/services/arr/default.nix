{
  config,
  lib,
  pkgs,
  ...
}: {
  options.snowflake.services.arr = {
    enable = lib.mkEnableOption "Enable arr suite configuration";
    jellyfin.enable = lib.mkEnableOption "Enable jellyfin configuration for NixOS";
    # mediaDir = lib.mkOption {
    # type = lib.types.path;
    # description = "Path to media storage directory, accessible by all *arr suite applications";
    # };
  };

  config = let
    cfg = config.snowflake.services.arr;
  in
    lib.mkIf cfg.enable {
      services.jellyfin = {
        enable = cfg.jellyfin.enable;
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
      };

      hardware.graphics = {
        enable = true;
        extraPackages = with pkgs; [
          intel-media-driver
          intel-compute-runtime
          onevpl-intel-gpu
          libvdpau-va-gl
        ];
      };

      services.jellyseerr.enable = true;
      services.jellyseerr.openFirewall = true;
    };
}
