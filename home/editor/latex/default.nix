{ config
, pkgs
, ...
}: {
  home.packages = with pkgs; [
    texliveFull
    python311Packages.accessible-pygments
  ];

  home.file.".latexmkrc".source = ./latexmkrc;
}
