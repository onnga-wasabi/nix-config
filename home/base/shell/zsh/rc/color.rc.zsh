export ZSH_LS_BACKEND=eza
export CLICOLOR=1
export TERM=xterm-256color
export EZA_COLORS="$(vivid generate iceberg-dark)"
export LS_COLORS="${EZA_COLORS}"

zstyle ':completion:*' list-colors "${(s.:.)EZA_COLORS}"
