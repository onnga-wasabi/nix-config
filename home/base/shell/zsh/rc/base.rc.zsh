export LANG=en_US.UTF-8
export EDITOR=nvim
eval "$(direnv hook zsh)"

# C-w でいい感じに削除できるように
export WORDCHARS="*?_-.[]~&;=!#$%^(){}<>"

# SQLite3 の設定
# https://github.com/kkharji/sqlite.lua/blob/d0ffd703b56d090d213b497ed4eb840495f14a11/lua/sqlite/defs.lua#L18
_SQLITE3_DIR=$(ls /nix/store/ | rg sqlite-$(sqlite3 --version | cut -d ' ' -f 1)$ | head -n 1)
export LIBSQLITE="/nix/store/${_SQLITE3_DIR}/lib/libsqlite3.dylib"

export PATH=${PATH}:${HOME}/.local/bin

LOCAL_ZSH_RC=${XDG_CONFIG_HOME}/zsh/rc/local.rc.zsh
if [ -f ${LOCAL_ZSH_RC} ]; then
  source ${LOCAL_ZSH_RC}
fi
