{ pkgs
, ...
}: {
  home.packages = with pkgs; [
    (google-cloud-sdk.withExtraComponents
      ([
        google-cloud-sdk.components.config-connector
      ]))
  ];
}
