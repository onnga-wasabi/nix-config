{ pkgs
, ...
}:
let
  inherit (pkgs) system;
  customPkgs = {
    commitizen =
      let
        pkgs = import
          (builtins.fetchTarball {
            url = "https://github.com/NixOS/nixpkgs/archive/92d295f588631b0db2da509f381b4fb1e74173c5.tar.gz";
            sha256 = "162w28y4i5c8g5qhjvs827qxphf2a8n4c8fwhcywzl1j1a35h2im";
          })
          {
            inherit system;
          };
      in
      pkgs.commitizen;
    tig =
      let
        pkgs = import
          (builtins.fetchTarball {
            url = "https://github.com/NixOS/nixpkgs/archive/e3945057be467f32028ff6b67403be08285ad8c8.tar.gz";
            sha256 = "0jxwgnraha203yd4vw2n61vd99fgrhrvda374zidx6pw1xj88hhy";
          })
          {
            inherit system;
          };
      in
      pkgs.tig;
  };
in
{
  home.packages = with pkgs; [
    git
    gh
    delta
    lazygit
    libgit2
    customPkgs.tig
    customPkgs.commitizen
  ];

  xdg.configFile."git" = {
    source = ./rc/git;
    recursive = true;
  };
  xdg.configFile."tig" = {
    source = ./rc/tig;
    recursive = true;
  };
  xdg.configFile."delta" = {
    source = ./rc/delta;
    recursive = true;
  };
  xdg.configFile."lazygit" = {
    source = ./rc/lazygit;
    recursive = true;
  };
}
