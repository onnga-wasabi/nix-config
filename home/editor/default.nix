{ pkgs
, ...
}: {
  imports = [
    ./cspell
    ./latex
    ./nvim
    ./obsidian
    ./vscode
  ];
}
