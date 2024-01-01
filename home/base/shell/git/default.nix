{ config
, pkgs
, ...
}: {
  home.packages = with pkgs; [
    gitui
    tig
  ];

  xdg.configFile."tig/config".source = ./tigrc;
  xdg.configFile."git/config".source = ./gitconfig;
  xdg.configFile."git/ignore".source = ./ignore;
}
