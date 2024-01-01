{ pkgs, ... }: {
  imports = [
    ./daemon
    ./shell
  ];
  home.packages = with pkgs; [
    coreutils
    asdf-vm
  ];
  xdg = {
    enable = true;
  };
}
