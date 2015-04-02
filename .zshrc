####
# .zshrc file
#
# Maintainer  : Tomoyuki MARUTA <tomoyuki.maruta@gmail.com>
# Based On    : Sotaro KARASAWA <sotaro.k@gmail.com>
# Last Change : 2014/04/09
# https://github.com/marucc/dotfiles
####

export LANG=ja_JP.UTF-8

# パスの設定
PATH=$HOME/pear/bin:$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH:/sbin:/usr/sbin
export MANPATH=/usr/local/man:/usr/share/man

# mysql
export MYSQL_PS1="\u@\h[\d]> "

# エディタを vim に設定
export SVN_EDITOR="vim"
export EDITOR="vim"
export CLICOLOR=1
export SCREENDIR=$HOME/.screen
export LSCOLORS=ExFxCxDxBxegedabagacad

# anyenv
if [ -d $HOME/.anyenv ] ; then
    export PATH="$HOME/.anyenv/bin:$PATH"
    eval "$(anyenv init -)"
    eval "$(rbenv init -)"
    eval "$(ndenv init -)"
 fi

# python
PYENV=`which-command pyenv`
VIRTUALENVWRAPPER=`$PYENV which virtualenvwrapper.sh || echo '/usr/local/bin/virtualenvwrapper.sh'`
if [ -e $VIRTUALENVWRAPPER ]; then
    export VIRTUALENVWRAPPER_PYTHON=`$PYENV which python2.7`
    export WORKON_HOME=${HOME}/venvs
    export PIP_DOWNLOAD_CACHE=${HOME}/.pip_cache
    export PIP_RESPECT_VIRTUALENV=true
    export PIP_REQUIRE_VIRTUALENV=true
    source $VIRTUALENVWRAPPER
fi

# zsh-notify/notify.plugin
if [ -e /usr/local/bin/terminal-notifier ]; then
    export SYS_NOTIFIER="/usr/local/bin/terminal-notifier"
    if [ -e ~/.zshrc.d/zsh-notify/notify.plugin.zsh ]; then
        autoload add-zsh-hook
        source ~/.zshrc.d/zsh-notify/notify.plugin.zsh
    fi
fi

# 関数
find-grep () { find . -type f -print | xargs grep -n --binary-files=without-match $@ }
grepv () { grep -irn --binary-files=without-match $@ * | grep -v svn }

fpath=(~/.zshrc.d/completion $fpath)

#Dircolorの読み込み
## 補完候補の色づけ
export ZLS_COLORS=$LS_COLORS
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
if [ -e /usr/local/share/zsh-completions ]; then
    fpath=(/usr/local/share/zsh-completions $fpath)
fi

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

if [ -e /Applications/MacVim.app/Contents/MacOS/Vim ]; then
    export EDITOR=/Applications/MacVim.app/Contents/MacOS/Vim
    alias vim='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
fi

alias ll='ls -l'
alias la='ls -la'
alias dh='df -h'
alias vi='vim'
alias v='vim'
alias gd='dirs -v; echo -n "select number: "; read newdir; cd +"$newdir"'

alias st='svn info; svn st'
alias stu='svn st -u'
alias stg='repos=`svn info|grep "URL: .*trunk"|sed "s/URL: \(.*\)trunk/\1/"`;list=`svn ls ${repos}tags`;echo -ne $list|grep "^release_"|sed "s/release_\(.*\)\//\1/"|sort -t . -k 1,1 -k 2,2n -k 3,3n|sed "s/\(.*\)/release_\1/";echo -ne $list|grep -v "^release_"|sort'
alias stl='stg'
alias sdi='svn di'
alias sad='svn add'
alias smv='svn mv'
alias srm='svn rm'
alias sp='svn up'
alias sup='svn up'
alias sci='svn ci'

alias gst='git status'
alias gtg='git tag'
alias gtl='list=`git tag`;echo -ne $list|grep "^release_"|sed "s/release_\(.*\)/\1/"|sort -t . -k 1,1 -k 2,2n -k 3,3n|sed "s/\(.*\)/release_\1/";echo -ne $list|grep -v "^release_"|sort'
alias gbl='git branch'
alias gbls='git remote prune origin;git branch -a'
alias gdi='git diff'
alias gad='git add'
alias gmv='git mv'
alias grm='git rm'
alias gci='git commit'
alias gcia='git commit -a'
gps() {
    BUF=`git push 2>&1`
    CMD=`echo "$BUF" | grep 'git push --set-upstream origin' | sed 's/ *//'`
    if [ -n "$CMD" ]; then
        echo -n "${CMD} [Y/n] "
        read ANSWER
        case `echo $ANSWER | tr y Y` in
            "" | Y* )
                eval "$CMD" && git push --tags
                ;;
        esac
    else
      git push --tags
      echo "$BUF"
    fi
}
alias gpl='git pull;git pull --tag'
alias gmg='git pull origin'
alias gco='git checkout'

alias hst='echo -n "# On branch ";hg branch; hg --config "extensions.color=" status'
alias hbl='hg --config "extensions.color=" branch'
alias hbls='hg --config "extensions.color=" branches'
hdi() {
    hg --config "extensions.color=" diff --color=always $1 | less -R
}
alias had='hg add'
alias hrm='hg rm'
alias hci='hg commit'
alias hps='hg push'
alias hpl='hg pull;hg update'
alias hup='hg update'
alias hmg='hg merge -r'
hco() {
    hst
    FROM=`hg branch`
    TO=$1
    hg pull
    RET=`hg update -c -r $TO`
    if [ -n "$RET" ]; then
        hg --config "extensions.color=" update -r $TO
        hg --config "extensions.color=" diff -r $FROM --stat
    fi
}


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

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# added by travis gem
[ -f /Users/maru/.travis/travis.sh ] && source /Users/maru/.travis/travis.sh
###-begin-nativescript-completion-###
if complete &>/dev/null; then
  _nativescript_completion () {
    local si="$IFS"
    IFS=$'\n' COMPREPLY=($(COMP_CWORD="$COMP_CWORD" \
                           COMP_LINE="$COMP_LINE" \
                           COMP_POINT="$COMP_POINT" \
                           nativescript completion -- "${COMP_WORDS[@]}" \
                           2>/dev/null)) || return $?
    IFS="$si"
  }
  complete -F _nativescript_completion -o default nativescript
elif compctl &>/dev/null; then
  _nativescript_completion () {
    local cword line point words si
    read -Ac words
    read -cn cword
    let cword-=1
    read -l line
    read -ln point
    si="$IFS"
    IFS=$'\n' reply=($(COMP_CWORD="$cword" \
                       COMP_LINE="$line" \
                       COMP_POINT="$point" \
                       nativescript completion -- "${words[@]}" \
                       2>/dev/null)) || return $?
    IFS="$si"
  }
  compctl -K _nativescript_completion -f nativescript
fi
###-end-nativescript-completion-######-begin-tns-completion-###
if complete &>/dev/null; then
  _tns_completion () {
    local si="$IFS"
    IFS=$'\n' COMPREPLY=($(COMP_CWORD="$COMP_CWORD" \
                           COMP_LINE="$COMP_LINE" \
                           COMP_POINT="$COMP_POINT" \
                           tns completion -- "${COMP_WORDS[@]}" \
                           2>/dev/null)) || return $?
    IFS="$si"
  }
  complete -F _tns_completion -o default tns
elif compctl &>/dev/null; then
  _tns_completion () {
    local cword line point words si
    read -Ac words
    read -cn cword
    let cword-=1
    read -l line
    read -ln point
    si="$IFS"
    IFS=$'\n' reply=($(COMP_CWORD="$cword" \
                       COMP_LINE="$line" \
                       COMP_POINT="$point" \
                       tns completion -- "${words[@]}" \
                       2>/dev/null)) || return $?
    IFS="$si"
  }
  compctl -K _tns_completion -f tns
fi
###-end-tns-completion-###
