####
# .zshrc file
#
# Maintainer  : Tomoyuki MARUTA <tomoyuki.maruta@gmail.com>
# Based On    : Sotaro KARASAWA <sotaro.k@gmail.com>
# Last Change : 2026/01/18
# https://github.com/marucc/dotfiles
####

export LANG=ja_JP.UTF-8

# パスの設定
export PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH:/sbin:/usr/sbin
[ -d "$HOME/Library/Android/sdk/platform-tools" ] && export PATH="$PATH:$HOME/Library/Android/sdk/platform-tools"
export MANPATH=/usr/local/man:/usr/share/man

# homebrew
if [ -e "/opt/homebrew/bin/brew" ] ; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# direnv
# brew install direnv
# 対象ディレクトリに.envrcを作成し、direnv allowで許可
if command -v direnv &> /dev/null; then
    eval "$(direnv hook zsh)"
fi

# mysql
export MYSQL_PS1="\u@\h[\d]> "

# エディタを vim に設定
export EDITOR="vim"
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

# colima（Docker Desktop が無い場合）
if command -v colima &> /dev/null && [ ! -e /Applications/Docker.app ]; then
    export DOCKER_HOST="unix://${HOME}/.colima/default/docker.sock"
fi

# mise
if command -v mise &> /dev/null; then
    eval "$(mise activate zsh)"
fi

# Emacs 風キーバインド（個別 bindkey より前に置く）
bindkey -e

# fzf
if command -v fzf &> /dev/null; then
    eval "$(fzf --zsh)"

    # Ctrl+r で履歴に候補がない場合や Esc キャンセル時に、入力文字列をコマンドラインに残す
    fzf-history-widget-with-fallback() {
        local original="$LBUFFER" result
        result=$(fc -rl 1 | awk '{$1=""; sub(/^ /, ""); print}' | \
            fzf --query="$LBUFFER" --no-sort --print-query --expect=esc +m)
        # 1行目: クエリ, 2行目: 押されたキー (Enter=空, Esc="esc"), 3行目以降: 選択項目
        local lines=("${(@f)result}")
        local query="${lines[1]}"
        local key="${lines[2]}"
        local selected="${lines[3]}"
        if [[ "$key" == "esc" ]]; then
            # Esc: クエリのみ使う (選択項目は捨てる)
            LBUFFER="${query:-$original}"
        elif [[ -n "$selected" ]]; then
            # Enter + 選択項目あり
            LBUFFER="$selected"
        elif [[ -n "$query" ]]; then
            # Enter + 候補なし: クエリを使う
            LBUFFER="$query"
        else
            LBUFFER="$original"
        fi
        zle redisplay
    }
    zle -N fzf-history-widget-with-fallback
    bindkey '^R' fzf-history-widget-with-fallback
fi

# zoxide
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
fi

# zsh-auto-notify
if [ -e ~/.zshrc.d/zsh-auto-notify/auto-notify.plugin.zsh ]; then
    source ~/.zshrc.d/zsh-auto-notify/auto-notify.plugin.zsh
    AUTO_NOTIFY_THRESHOLD=30
    AUTO_NOTIFY_IGNORE=("vim" "vi" "ssh" "tmux" "man" "less" "more" "claude")
fi

# 関数
find-grep () { find . -type f -print | xargs grep -n --binary-files=without-match $@ }
grepv () { grep -irn --binary-files=without-match $@ * | grep -v svn }

#Dircolorの読み込み
## 補完候補の色づけ
export ZLS_COLORS=$LS_COLORS
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# エイリアスの設定
if command -v eza &> /dev/null; then
    ls() { command eza --icons "$@" }
    ll() { command eza -l --icons "$@" }
    la() { command eza -la --icons "$@" }
    tree() { command eza --tree --icons "$@" }
else
    case "${OSTYPE}" in
    darwin*)
        alias ls='ls -G'
        ;;
    linux*)
        alias ls='ls --color=auto'
        ;;
    esac
    alias ll='ls -l'
    alias la='ls -la'
fi
alias dh='df -h'
alias vi='vim'
alias v='vim'
alias gd='dirs -v; echo -n "select number: "; read newdir; cd +"$newdir"'

alias claude-code='mise x node@22 -- npx "@anthropic-ai/claude-code@latest"'

alias gst='git status'
alias gtg='git tag'
alias gtl='list=`git tag`;echo -ne $list|grep "^v"|sed "s/v\(.*\)/\1/"|sort -t . -k 1,1 -k 2,2n -k 3,3n|sed "s/\(.*\)/v\1/";echo -ne $list|grep -v "^v"|sort'
alias gbr='git branch'
alias gbl='git fetch --prune && git branch -vv | grep ": gone]" | awk "{print $1}" | xargs -r git branch -d 2>&1 | grep -v "not found"; git branch'
alias gbla='gbl -a'
alias gdi='git diff'
alias gad='git add'
alias gmv='git mv'
alias grm='git rm'
alias gci='git commit'
alias gcia='git commit -a'
alias gps='git push;git push --tags'
alias gpsf='git push --force-with-lease;git push --tags'
alias gpl='git pull;git pull --tag'
alias gmg='git pull origin'
alias gco='git checkout'
alias gsw='git switch'

# プロンプトの設定
autoload colors
#colors

case ${UID} in
0)
    PROMPT="%B%{[31m%}%n@%m#%{[m%}%b "
    PROMPT2="%B%{[31m%}%_#%{[m%}%b "
    SPROMPT="%B%{[31m%}%r is correct? [n,y,a,e]:%[m%}%b "
    #[ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
        #PROMPT="%{[37m%}${HOST%%.*} ${PROMPT}"
;;
*)
    PROMPT="%{[36m%}%n%%%{[m%} "
    PROMPT2="%{[35m%}%_%%%{[m%} "
    SPROMPT="%{[31m%}%r is correct? [n,y,a,e]:%{[m%} "
    [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
        PROMPT="%{[37m%}${HOST%%.*} ${PROMPT}"
;;
esac

autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '(%s) %b '
zstyle ':vcs_info:*' actionformats '(%s) %b|%a '
precmd () {
        psvar=()
            LANG=en_US.UTF-8 vcs_info
                [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
RPROMPT="%1(v|%F{green}%1v%f|)[%~]"

setopt prompt_subst


## ビープを鳴らさない
setopt nobeep

## 補完候補一覧でファイルの種別をマーク表示
setopt list_types

## 補完候補を一覧表示
setopt auto_list

# ヒストリの設定
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000

# 履歴ファイルに時刻を記録
setopt extended_history

# 補完するかの質問は画面を超える時にのみに行う｡
LISTMAX=0

# zsh-completions (brew install zsh-completions)
if type brew &>/dev/null && [ -d "$(brew --prefix)/share/zsh-completions" ]; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
fi

# 補完の利用設定
autoload -Uz compinit; compinit -u

# eza 関数の補完
if command -v eza &> /dev/null; then
    compdef _files ls ll la tree
fi

# sudo でも補完の対象
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin

# cdのタイミングで自動的にpushd
setopt auto_pushd

# 複数の zsh を同時に使う時など history ファイルに上書きせず追加
setopt append_history

# 補完キー（Tab, Ctrl+I) を連打するだけで順に補完候補を自動で補完機能Off
#setopt no_auto_menu

# カッコの対応などを自動的に補完
setopt auto_param_keys

# ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt auto_param_slash

# ビープ音を鳴らさないようにする
setopt NO_beep

# 直前と同じコマンドラインはヒストリに追加しない
setopt hist_ignore_dups

# 重複したヒストリは追加しない
setopt hist_ignore_all_dups

# ヒストリを呼び出してから実行する間に一旦編集できる状態になる
setopt hist_verify

# auto_list の補完候補一覧で、ls -F のようにファイルの種別をマーク表示しない
setopt NO_list_types

# コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる
setopt magic_equal_subst

# ファイル名の展開でディレクトリにマッチした場合末尾に / を付加する
setopt mark_dirs

# 8 ビット目を通すようになり、日本語のファイル名を表示可能
setopt print_eight_bit

# シェルのプロセスごとに履歴を共有
setopt share_history

# Ctrl+wで､直前の/までを削除する｡
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# ディレクトリを水色にする｡
#export LS_COLORS='di=01;36'

# ファイルリスト補完でもlsと同様に色をつける｡
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

## 補完候補のカーソル選択を有効に
zstyle ':completion:*:default' menu select=1

# ディレクトリ名だけで､ディレクトリの移動をする｡
setopt auto_cd

# C-s, C-qを無効にする。
setopt NO_flow_control

# 改行がなくても表示
unsetopt promptcr

# ジョブ
unsetopt hup
setopt nocheckjobs

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/lib/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/lib/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/lib/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/lib/google-cloud-sdk/completion.zsh.inc"; fi

