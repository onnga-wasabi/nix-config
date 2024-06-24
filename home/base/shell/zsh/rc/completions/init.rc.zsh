# inspierd by https://oovu70.hatenadiary.org/entry/20120405/p1

# completion enable
autoload -U compinit
compinit

# basic
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z} r:|[-_.]=**'
zstyle ':completion:*:processes' menu yes select=2
zstyle ':completion:*:default' menu select=1

bindkey "^[[Z" reverse-menu-complete # Shift-Tabで補完候補を逆順する("\e[Z"でも動作する)

# glob
setopt extended_glob # グロブ機能を拡張する
unsetopt caseglob    # ファイルグロブで大文字小文字を区別しない

# tool specific
ZSH_COMPLETION_HOME="${XDG_CONFIG_HOME}/zsh/rc/completions"
source "${ZSH_COMPLETION_HOME}/cloud_sql_proxy.zsh"
source "${ZSH_COMPLETION_HOME}/alloydb_auth_proxy.zsh"
