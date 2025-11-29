{ pkgs
, ...
}: {
  imports = [
    ./hammerspoon
    ./wezterm
  ];
  home.packages = with pkgs; [
    dbeaver-bin
    postgresql
    sqlite
    pgcli
    openssl
    curl
    ffmpeg
    gemini-cli
  ];
}
