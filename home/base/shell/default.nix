{ pkgs
, ...
}: {
  imports = [
    ./git
    ./k8s
    ./tmux
    ./gcp
    ./zsh
  ];
}
