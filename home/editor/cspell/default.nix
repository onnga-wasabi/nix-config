{ config
, pkgs
, ...
}: {
  home.packages = with pkgs; [
    cspell
  ];

  xdg.configFile."cspell/cspell.yaml".source = ./cspell.yaml;
}
