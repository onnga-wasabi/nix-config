{ pkgs
, ...
}: {
  home.packages = with pkgs; [
    tmux
  ];

  xdg.configFile."tmux/tmux.conf".source = ./tmux.conf;
  xdg.configFile."tmux/iceberg.tmux.conf".source = ./iceberg.tmux.conf;
}
