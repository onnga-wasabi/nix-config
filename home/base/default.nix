{ pkgs, ... }: {
  imports = [
    ./daemon
    ./shell
  ];
  home.packages = with pkgs; [
    cmake
    coreutils
    gnused
    inetutils
    nixpkgs-fmt
    pkg-config
    devbox
  ];
  xdg = {
    enable = true;
  };
}
