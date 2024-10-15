export LANG=en_US.UTF-8
export EDITOR=nvim
eval "$(direnv hook zsh)"

# Options
setopt hist_ignore_all_dups
setopt hist_ignore_dups

# C-w でいい感じに削除できるように
export WORDCHARS="*?_-.[]~&;=!#$%^(){}<>"

# SQLite3 の設定
# https://github.com/kkharji/sqlite.lua/blob/d0ffd703b56d090d213b497ed4eb840495f14a11/lua/sqlite/defs.lua#L18
_SQLITE3_DIR=$(ls /nix/store/ | rg sqlite-$(sqlite3 --version | cut -d ' ' -f 1)$ | head -n 1)
export LIBSQLITE="/nix/store/${_SQLITE3_DIR}/lib/libsqlite3.dylib"

# Libgit2
export LIBGIT2=$(ls /nix/store | rg libgit2 | xargs -I{} find /nix/store/{} -name '*.dylib' | head -n 1)

export PATH=${PATH}:${HOME}/.local/bin
export PATH=${PATH}:${HOME}/.docker/bin

LOCAL_ZSH_RC=${XDG_CONFIG_HOME}/zsh/rc/local.rc.zsh
if [ -f ${LOCAL_ZSH_RC} ]; then
  source ${LOCAL_ZSH_RC}
fi

#memo
# function fzf-select-history() {BUFFER=$(history 1 | sort -r -k 2 | uniq -1 | sort -r | awk '$1=$1' | cut -d" " -f 2- | fzf --query "$LBUFFER" --reverse);CURSOR=$#BUFFER;zle reset-prompt}
