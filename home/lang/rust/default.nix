{ pkgs
, lib
, ...
}:
{
  home.packages = with pkgs; [
    cargo
    rustfmt
  ];
}
