{ pkgs
, ...
}: {
  home.packages = with pkgs; [
    k9s
    kube-score
    kubectl
    kubectx
    kustomize
    stern
  ];

  # k9s
  # config には書き込み権限を与えて更新され続けるので一度作成してからローカルにだけ反映する
  xdg.configFile."k9s/skins" = {
    source = ./k9s/skins;
    recursive = true;
  };
}
