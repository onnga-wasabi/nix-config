{ pkgs
, ...
}: {
  home.packages = with pkgs; [
    tmux
  ];

  xdg.configFile."tmux/tmux.conf".source = ./tmux.conf;
  xdg.configFile."tmux/iceberg.tmux.conf".source = ./iceberg.tmux.conf;

  # プラグインは tpm で clone せず nixpkgs から供給し、tmux.conf から source-file する。
  # continuum は resurrect に依存するので resurrect を先に読み込む。
  xdg.configFile."tmux/plugins.tmux.conf".text = ''
    run-shell ${pkgs.tmuxPlugins.sensible.rtp}
    run-shell ${pkgs.tmuxPlugins.yank.rtp}
    run-shell ${pkgs.tmuxPlugins.resurrect.rtp}
    run-shell ${pkgs.tmuxPlugins.continuum.rtp}
  '';
}
