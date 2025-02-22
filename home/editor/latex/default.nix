{ pkgs
, ...
}: {
  home.packages = with pkgs; [
    texliveFull
    pandoc
    python311Packages.accessible-pygments
  ];

  home.file.".latexmkrc".source = ./latexmkrc;
}
