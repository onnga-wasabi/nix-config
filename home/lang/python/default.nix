{ pkgs
, ...
}:
{
  home.packages = with pkgs; [
    poetry
    python311
  ];
}
