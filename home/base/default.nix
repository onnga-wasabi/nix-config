{ pkgs, ... }: {
  imports = [
    ./daemon
    ./shell
  ];
  home.packages = with pkgs; [
    actionlint
    cmake
    # coreutils
    inetutils
    nixd
    nixpkgs-fmt
    pkg-config
    devbox
  ];
  xdg = {
    enable = true;
  };
}
