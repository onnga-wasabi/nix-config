{ pkgs
, ...
}: {
  home.packages = with pkgs; [
    neovim
    sqlfluff
    nodePackages_latest.fixjson
    luajitPackages.luarocks

    # for obsidian
    pngpaste
    cmigemo
  ];

  xdg.configFile."nvim/init.lua".source = ./init.lua;
  xdg.configFile."nvim/lua" = {
    source = ./lua;
    recursive = true;
  };
}
