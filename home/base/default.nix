{ pkgs, ... }: {
  imports = [
    ./daemon
    ./shell
  ];
  home.packages = with pkgs; [
    coreutils
    neofetch
    asdf-vm
  ];
  xdg = {
    enable = true;
  };
}
