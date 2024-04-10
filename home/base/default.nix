{ pkgs, ... }: {
  imports = [
    ./daemon
    ./shell
  ];
  home.packages = with pkgs; [
    asdf-vm
    coreutils
    gnused
    neofetch
    neovim
    nixpkgs-fmt
    unar
    inetutils
  ];
  xdg = {
    enable = true;
  };
}
