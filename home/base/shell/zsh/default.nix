{ config
, pkgs
, ...
}:
{
  home.packages = with pkgs; [
    act
    bat
    csvq
    devbox
    difftastic
    entr
    eza
    fd
    fselect
    fzf
    go-migrate
    go-task
    graphviz
    jnv
    jq
    navi
    neofetch
    nkf
    ripgrep
    serpl
    tlrc
    unar
    vivid
    wireshark
    xdg-ninja
    yq
    yt-dlp
  ];

  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    initContent = builtins.readFile ./zshrc;
  };

  xdg.configFile."zsh/rc" = {
    source = ./rc;
    recursive = true;
  };
  xdg.configFile."zsh/functions" = {
    source = ./functions;
    recursive = true;
  };

  # 本体は xdg 配下に置けない
  home.file.".p10k.zsh".source = ./rc/p10k.zsh;
}
