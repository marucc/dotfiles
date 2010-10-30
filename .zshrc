####
# .zshrc file
#
# Maintainer  : Sotaro KARASAWA <sotaro.k@gmail.com>
# Last Change : 2008/11/16
# Version     : 0.2.1
####

export LANG=ja_JP.UTF-8

# パスの設定
PATH=/opt/local/bin:/usr/local/bin:$PATH:/sbin:/usr/sbin
export MANPATH=/usr/local/man:/usr/share/man

# エディタを vim に設定
export SVN_EDITOR="vim"
export EDITOR="vim"
export CLICOLOR=1
export SCREENDIR=$HOME/.screen
export LSCOLORS=ExFxCxDxBxegedabagacad

# 関数
find-grep () { find . -type f -print | xargs grep -n --binary-files=without-match $@ }
grepv () { grep -irn --binary-files=without-match $@ * | grep -v svn }

fpath=(~/.zshrc.d/completion $fpath)

#Dircolorの読み込み
## 補完候補の色づけ
export ZLS_COLORS=$LS_COLORS
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# エイリアスの設定
case "${OSTYPE}" in
darwin*)
    alias ls='ls -G'
    ;;
linux*)
    # eval `dircolors -b ~/.dircolors`
    alias ls='ls --color=auto'
    ;;
esac

alias ll='ls -l'
alias la='ls -la'
alias dh='df -h'
alias vi='vim'
alias v='vim'
alias st='svn st'
alias stu='svn st -u'
alias sd='svn di'
alias sdi='svn di'
alias sad='svn add'
alias sp='svn up'
alias sup='svn up'
alias sci='svn ci'
alias gd='dirs -v; echo -n "select number: "; read newdir; cd +"$newdir"'
alias gst='git status'
alias gci='git commit'
alias gdi='git diff'
alias gad='git add'
alias gps='git push'
alias gpl='git pull'

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
RPROMPT=" [%~]"

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

# 補完の利用設定
autoload -Uz compinit; compinit -u

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

# Emasc 風キーバインド
bindkey -e

# screen のステータスバーに現在実行中のコマンドを表示
# cd をしたときにlsを実行する
# ref. http://nijino.homelinux.net/diary/200206.shtml#200206140
if [ "$TERM" = "screen" ]; then
chpwd () {
    echo -n "_`dirs`\\"
    ls
}
preexec() {
# see [zsh-workers:13180]
# http://www.zsh.org/mla/workers/2000/msg03993.html
    emulate -L zsh
        local -a cmd; cmd=(${(z)2})
        case $cmd[1] in
        fg)
        if (( $#cmd == 1 )); then
            cmd=(builtin jobs -l %+)
        else
            cmd=(builtin jobs -l $cmd[2])
                fi
                ;;
    %*) 
        cmd=(builtin jobs -l $cmd[1])
        ;;
    cd)
        if (( $#cmd == 2)); then
            cmd[1]=$cmd[2]
                fi
                ;&
                *)
                echo -n "k$cmd[1]:t\\"
                return
                ;;
    esac

        local -A jt; jt=(${(kv)jobtexts})

        $cmd >>(read num rest
                cmd=(${(z)${(e):-\$jt$num}})
                echo -n "k$cmd[1]:t\\") 2>/dev/null
}
chpwd
fi
