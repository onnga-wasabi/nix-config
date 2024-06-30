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
  };
in
{
  home.packages = with pkgs; [
    git
    gh
    delta
    lazygit
    customPkgs.commitizen
  ];

  xdg.configFile."git" = {
    source = ./rc/git;
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
