{ pkgs
, ...
}:
{
  home.packages = with pkgs; [
    stylua
    lua51Packages.lua
    lua51Packages.luarocks
  ];
}
