# vim
alias vim='echo "vimなんかありませーん, use n instead of vim"'
alias n=nvim
alias vimdiff="nvim -d"

# ls
alias ls="eza --icons=auto"
alias l="ls"
alias ll="ls -l --git"
alias la="ls --git --all"
alias lla="ll --all"

# rm
alias rm="rm -i"

# misc
alias realpath="(){ls --no-icons $1(:a)}"
alias loadenv="(){set -a; source $1; set +a;}"
alias ..="cd .."
alias ...="cd ../.."
alias nd-init='echo "use nix" >> .envrc && direnv allow'

# Tools
alias sed=gsed
alias ks=k9s
alias k=kubectl
alias kc=kubectx
alias kn=kubens
alias go=richgo
alias lg=lazygit
