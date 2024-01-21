{ config
, pkgs
, ...
}: {
  home.packages = with pkgs; [
    neovim
    sqlfluff
    nodePackages_latest.fixjson
  ];

  xdg.configFile."nvim/init.lua".source = ./init.lua;
  xdg.configFile."nvim/lua" = {
    source = ./lua;
    recursive = true;
  };
  xdg.dataFile."zettelkasten/templates" = {
    source = ./telekasten-templates;
    recursive = true;
  };
}
