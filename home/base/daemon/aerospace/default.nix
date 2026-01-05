{ pkgs
, ...
}:
{
  home.packages = [
    pkgs.aerospace
    pkgs.jankyborders # https://github.com/FelixKratz/JankyBorders
  ];
  # programs = {
  #   jankyborders = {
  #     enable = true;
  #   };
  # };

  xdg.configFile."aerospace/aerospace.toml".source = ./aerospace.toml;
  xdg.configFile."borders/bordersrc".source = ./bordersrc;
}
