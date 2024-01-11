{ config
, pkgs
, ...
}: {
  home.packages = with pkgs; [
    nodePackages.cspell
  ];

  xdg.configFile."cspell/cspell.yaml".source = ./cspell.yaml;
}
