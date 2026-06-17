{ pkgs
, ...
}:
{
  home.packages = with pkgs; [
    poetry
    python311
    # LSP / formatter / linter
    pyright
    ruff
  ];
}
