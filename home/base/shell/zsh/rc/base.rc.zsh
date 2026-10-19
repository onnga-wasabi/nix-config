export LANG=en_US.UTF-8
export EDITOR=nvim
eval "$(direnv hook zsh)"

# Options
setopt hist_ignore_all_dups
setopt hist_ignore_dups

# C-w でいい感じに削除できるように
export WORDCHARS="*?_-.[]~&;=!#$%^(){}<>"

# Libgit2
# export LIBGIT2=$(ls /nix/store | rg libgit2 | xargs -I{} find /nix/store/{} -name '*.dylib' | head -n 1)

export PATH=${PATH}:${HOME}/.local/bin
export PATH=${PATH}:${HOME}/.docker/bin

LOCAL_ZSH_RC=${XDG_CONFIG_HOME}/zsh/rc/local.rc.zsh
if [ -f ${LOCAL_ZSH_RC} ]; then
  source ${LOCAL_ZSH_RC}
fi

#memo
# function fzf-select-history() {BUFFER=$(history 1 | sort -r -k 2 | uniq -1 | sort -r | awk '$1=$1' | cut -d" " -f 2- | fzf --query "$LBUFFER" --reverse);CURSOR=$#BUFFER;zle reset-prompt}
