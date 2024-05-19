{ pkgs
, ...
}: {
  imports = [
    ./cspell
    ./latex
    ./nvim
    ./vscode
  ];
}
