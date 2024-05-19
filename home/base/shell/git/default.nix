{ config
, pkgs
, ...
}:
{
  home.packages = with pkgs; [
    commitizen
    # gh # upgrade の頻度がたかいので手動で管理
    gitui
    lazygit
    tig
  ];

  xdg.configFile."tig/config".source = ./tigrc;
  xdg.configFile."git/config".source = ./gitconfig;
  xdg.configFile."git/ignore".source = ./ignore;
  xdg.configFile."gitui/key_bindings.ron".source = ./key_bindings.ron;
}
