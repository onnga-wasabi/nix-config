{ pkgs
, ...
}: {
  imports = [
    # ./hammerspoon
    ./wezterm
    ./sketchybar
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
    aerospace
  ];
}
