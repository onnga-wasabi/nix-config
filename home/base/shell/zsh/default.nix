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
  ];

  programs.zsh = {
    enable = true;
    # for the environment variables
    envExtra = ''
      export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
    '';
  };

  xdg.configFile."zsh/.zshrc".source = ./zshrc;
}
