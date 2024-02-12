{ config
, pkgs
, ...
}: {
  home.packages = with pkgs; [
    bat
    difftastic
    nkf
    eza
    fd
    fselect
    fzf
    go-migrate
    go-task
    jq
    navi
    ripgrep
    vivid
    xdg-ninja
  ];

  programs.zsh = {
    enable = true;
    # for the environment variables
    envExtra = ''
      export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
    '';
  };

  xdg.configFile."zsh/.zshrc".source = ./zshrc;
  xdg.configFile."zsh/rc" = {
    source = ./rc;
    recursive = true;
  };
  xdg.configFile."zsh/functions" = {
    source = ./functions;
    recursive = true;
  };

  # 本体は xdg 配下に置けない
  home.file.".p10k.zsh".source = ./rc/p10k.zsh;
}
