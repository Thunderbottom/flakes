_final: prev:
let
  version = "2.31.0";
in
{
  vuetorrent = prev.vuetorrent.overrideAttrs (_old: {
    inherit version;
    src = prev.fetchFromGitHub {
      owner = "VueTorrent";
      repo = "VueTorrent";
      rev = "v${version}";
      hash = "sha256-jWoD54cO1Tq9b2k8ySWUWQohT4qE0rW9EVJLoPi8DTA=";
    };
    npmDepsHash = "sha256-/B/DMTH/5e9YNJ9rl+HTGkAX1KzOoBB1PD68Li2sAAw=";
  });
}
