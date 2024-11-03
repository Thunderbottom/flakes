_: self: super: {
  # NOTE: this is just a workaround to build jellyfin-ffmpeg
  # successfully since the latest xev release has broken the
  # ffmpeg package until 7.1, or until the fix is merged in
  # nixos-unstable.
  # ref: https://github.com/NixOS/nixpkgs/pull/353198
  ffmpege_7-full = super.ffmpeg_7-full.override {
    withXevd = false;
    withXeve = false;
  };
}
