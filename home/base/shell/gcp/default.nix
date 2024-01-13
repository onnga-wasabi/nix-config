{ pkgs
, ...
}: {
  home.packages = with pkgs; [
    google-cloud-sql-proxy
    (google-cloud-sdk.withExtraComponents
      ([
        google-cloud-sdk.components.config-connector
        google-cloud-sdk.components.gke-gcloud-auth-plugin
      ]))
  ];
}
