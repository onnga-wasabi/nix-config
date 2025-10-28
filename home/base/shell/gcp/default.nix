{ pkgs
, ...
}:
let
  inherit (pkgs) system;
  customPkgs = {
    gcloud =
      let
        pkgs = import
          (builtins.fetchTarball {
            url = "https://github.com/NixOS/nixpkgs/archive/e6f23dc08d3624daab7094b701aa3954923c6bbb.tar.gz";
            sha256 = "14h025j1b2fwpadypgbas35v6d6hbds1kjp18fls34wh24chxxd1";
          })
          {
            inherit system;
          };
      in
      pkgs.google-cloud-sdk;
  };
in
{
  home.packages = with pkgs; [
    google-cloud-sql-proxy
    (customPkgs.gcloud.withExtraComponents
      ([
        customPkgs.gcloud.components.config-connector
        customPkgs.gcloud.components.gke-gcloud-auth-plugin
      ]))
  ];
}
