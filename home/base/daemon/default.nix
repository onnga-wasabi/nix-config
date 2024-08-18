{ pkgs
, ...
}: {
  imports = [
    ./hammerspoon
    ./wezterm
  ];
  home.packages = with pkgs; [
    postgresql
    sqlite
    pgcli
    openssl
    curl
  ];
}
