{ pkgs
, ...
}: {
  home.packages = with pkgs; [
    neovim
    sqlfluff
    nodePackages_latest.fixjson
    tree-sitter

    # obsidian
    pngpaste
    cmigemo
  ];

  xdg.configFile."nvim/init.lua".source = ./init.lua;
  xdg.configFile."nvim/lua" = {
    source = ./lua;
    recursive = true;
  };
}
