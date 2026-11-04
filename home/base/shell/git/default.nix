{ pkgs
, ...
}:
{
  home.packages = with pkgs; [
    git
    git-lfs
    gh
    ghx
    delta
    lazygit
    gitleaks
    commitizen
  ];
  # gh extensions (gh-dash, gh-enhance) は nixpkgs に揃っていないため
  # programs.gh.extensions での宣言管理ではなく gh extension install で手動管理する
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
  xdg.configFile."gh-dash" = {
    source = ./rc/gh-dash;
    recursive = true;
  };
  xdg.configFile."ghx" = {
    source = ./rc/ghx;
    recursive = true;
  };
}
