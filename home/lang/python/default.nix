{ config
, pkgs
, lib
, ...
}:
{
  home.packages = with pkgs; [
    poetry
    python312
  ];
}
