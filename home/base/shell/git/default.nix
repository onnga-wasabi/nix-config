{ config
, pkgs
, ...
}: {
  home.packages = with pkgs; [
    gitui
    tig
    commitizen
    lazygit
  ];

  xdg.configFile."tig/config".source = ./tigrc;
  xdg.configFile."git/config".source = ./gitconfig;
  xdg.configFile."git/ignore".source = ./ignore;
  xdg.configFile."gitui/key_bindings.ron".source = ./key_bindings.ron;
}
