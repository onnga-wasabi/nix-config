{ config
, pkgs
, ...
}:
{
  home.packages = with pkgs; [
    act
    asciinema
    asciinema-agg
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
    fastfetch
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
    docker-client # docker CLI + zsh 補完 (_docker)。daemon は別途 Docker Desktop / colima 等
    lazydocker
    miller # Like awk, sed, cut, join, and sort for data formats such as CSV, TSV, JSON, JSON Lines, and positionally-indexed
    pdftk # Command-line tool for working with PDFs
    watch
    uv
    pnpm
  ];

  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    initContent = builtins.readFile ./zshrc;
    completionInit = "autoload -U compinit && compinit -i";
    # プラグインは zinit で起動時に clone せず nixpkgs から供給する
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
    # zshrc の最後で読み込む必要があるので home-manager に任せる
    syntaxHighlighting.enable = true;
  };

  xdg.configFile."zsh/rc" = {
    source = ./rc;
    recursive = true;
  };
  xdg.configFile."zsh/functions" = {
    source = ./functions;
    recursive = true;
  };

  # sqlite.lua（nvim）が読む libsqlite3 の場所
  # https://github.com/kkharji/sqlite.lua/blob/d0ffd703b56d090d213b497ed4eb840495f14a11/lua/sqlite/defs.lua#L18
  home.sessionVariables.LIBSQLITE = "${pkgs.sqlite.out}/lib/libsqlite3.dylib";

  # 本体は xdg 配下に置けない
  home.file.".p10k.zsh".source = ./rc/p10k.zsh;
}
