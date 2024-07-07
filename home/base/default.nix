{ pkgs, ... }: {
  imports = [
    ./daemon
    ./shell
  ];
  home.packages = with pkgs; [
    asdf-vm
    coreutils
    gnused
    inetutils
    neofetch
    nixpkgs-fmt
    unar
    pkg-config
  ];
  xdg = {
    enable = true;
  };
}
