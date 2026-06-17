{ pkgs
, ...
}: {
  programs.neovim.enable = true;
  home.packages = with pkgs; [
    fixjson
    tree-sitter

    pngpaste
    cmigemo

    # 設定ファイル系の LSP / formatter / linter（特定の lang ディレクトリに属さないもの）
    yaml-language-server # yaml
    taplo # toml
    terraform-ls # terraform LSP
    tflint # terraform linter
    marksman # markdown LSP
    markdownlint-cli2 # markdown linter
    markdown-toc # markdown 目次生成
    sqlfluff # sql formatter / linter
  ];

  xdg.configFile."nvim/init.lua".source = ./init.lua;
  xdg.configFile."nvim/lua" = {
    source = ./lua;
    recursive = true;
  };
}
