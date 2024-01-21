{ config
, pkgs
, ...
}: {
  home.packages = with pkgs; [
    bat
    difftastic
    eza
    fzf
    go-task
    ripgrep
    vivid
    xdg-ninja
    go-migrate
    fd
    fselect
    jq
  ];

  programs.zsh = {
    enable = true;
    # for the environment variables
    envExtra = ''
      export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
    '';
  };

  xdg.configFile."zsh/.zshrc".source = ./zshrc;
  home.file.".p10k.zsh".source = ./p10k.zsh;
}
