{ config
, pkgs
, ...
}: {
  home.packages = with pkgs; [
    tmux
  ];

  home.file.".tmux.conf".source = ./tmux.conf;
  home.file.".tmux-powerlinerc".source = ./tmux-powerlinerc;
  xdg.configFile."tmux-powerline" = {
    source = ./tmux-powerline;
    recursive = true;
  };
}
