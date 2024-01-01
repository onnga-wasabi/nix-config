{ pkgs
, ...
}: {
  imports = [
    ./git
    ./k8s
    ./tmux
    ./zsh
  ];
}
