{ pkgs, ... }: {
  imports = [
    ./daemon
    ./shell
    ./hammerspoon
  ];
  home.packages = with pkgs; [
    asdf-vm
    coreutils
    gnused
    inetutils
    kitty
    neofetch
    nixpkgs-fmt
    unar
    yabai
    pkg-config
    wezterm
  ];
  xdg = {
    enable = true;
  };
}
