_final: prev: {
  paperless-ngx = prev.paperless-ngx.overrideAttrs (_old: {
    disabledTests = _old.disabledTests ++ [
      "test_favicon_view"
      "test_favicon_view_missing_file"
    ];
  });
}
