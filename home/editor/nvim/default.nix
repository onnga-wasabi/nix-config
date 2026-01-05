{ pkgs
, ...
}: {
  programs.neovim.enable = true;
  home.packages = with pkgs; [
    # sqlfluff
    nodePackages_latest.fixjson
    tree-sitter

    pngpaste
    cmigemo
  ];

  xdg.configFile."nvim/init.lua".source = ./init.lua;
  xdg.configFile."nvim/lua" = {
    source = ./lua;
    recursive = true;
  };
}
