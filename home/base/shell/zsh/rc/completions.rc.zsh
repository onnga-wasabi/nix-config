# completion
autoload -U compinit && compinit

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z} r:|[-_.]=**'
zstyle ':completion:*:processes' menu yes select=2
zstyle ':completion:*:default' menu select=1

