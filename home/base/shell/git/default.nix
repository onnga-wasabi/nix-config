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
    gitui
    lazygit
    customPkgs.tig
    customPkgs.commitizen
  ];

  xdg.configFile."tig/config".source = ./tigrc;
  xdg.configFile."git/config".source = ./gitconfig;
  xdg.configFile."git/ignore".source = ./ignore;
  xdg.configFile."gitui/key_bindings.ron".source = ./key_bindings.ron;
}
