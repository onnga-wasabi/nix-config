{ ...
}: {
  programs.zsh = {
    envExtra = ''
      export TF_CLI_CONFIG_FILE="$XDG_CONFIG_HOME/terraform/config.tfrc"
    '';
  };
  xdg.configFile."terraform/config.tfrc".source = ./config.tfrc;
}
