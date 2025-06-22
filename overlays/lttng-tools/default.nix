_final: prev: {
  lttng-tools = prev.lttng-tools.overrideAttrs (_old: {
    patches = [ ./fix-build.patch ];
  });
}
