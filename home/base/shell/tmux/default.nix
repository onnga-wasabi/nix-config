{ config
, pkgs
, ...
}: {
  home.packages = with pkgs; [
    tmux
  ];

  xdg.configFile."tmux/tmux.conf".source = ./tmux.conf;
  xdg.configFile."tmux-powerline/config.sh".source = ./tmux-powerlinerc;
}
