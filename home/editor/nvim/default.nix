{ pkgs
, ...
}: {
  home.packages = with pkgs; [
    neovim
    sqlfluff
    nodePackages_latest.fixjson
    luajitPackages.luarocks
    pngpaste
  ];

  xdg.configFile."nvim/init.lua".source = ./init.lua;
  xdg.configFile."nvim/lua" = {
    source = ./lua;
    recursive = true;
  };
}
