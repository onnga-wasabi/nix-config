{ pkgs
, ...
}: {
  imports = [
    ./cspell
    ./latex
    ./nvim
  ];
}
