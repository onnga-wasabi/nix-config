{ ... }: {
  programs = {
    sketchybar = {
      enable = true;
    };
  };
  xdg.configFile."sketchybar/sketchybarrc".source = ./sketchybarrc;
  xdg.configFile."sketchybar/plugins" = {
    source = ./plugins;
    recursive = true;
  };
}
