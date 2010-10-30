" .vimrc file
"
" Maintainer:   Sotaro KARASAWA <sotaro.k@gmail.com>
" Based On:     Daichi Kamemoto <daich@asial.co.jp>
" Last Change:  2008/09/24
" Version:      0.0.7.0
"
"""""


" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

"""""
" Initialize Settings
"""""
set nocompatible
set history=999
set encoding=utf-8

"""""
" Status line Settings
"""""
set laststatus=2
set ruler
set title
set showcmd
set showmode
" statuslineの表示設定。GetB()呼び出しも実行
set statusline=%<[%n]%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}\ [%{GetB()}]%=%l,%c%V%8P
" コマンドの補完をシェルっぽく
set wildmode=list:longest

"""""
" Behavior Settings
"""""
set backspace=indent,eol,start
set autoindent smartindent
set incsearch
" 検索文字列が小文字のときはCaseを無視。大文字が混在している場合は区別する。
set ignorecase
set smartcase
set wrapscan
" バッファが編集中でもファイルを開けるようにする
set hidden
" 編集中のファイルが外部のエディタから変更された場合には、自動で読み直し
set autoread
" tagsディレクトリを探し出してctagsを有効にする
if has("autochdir")
    set autochdir
    set tags=tags;
endif
" 前回終了したカーソル行に移動
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif

"""""
" View window Settings
"""""
set list
set listchars=tab:\ \ 
set number
set showmatch
set hlsearch
set wrap
set shiftwidth=4
set visualbell
set expandtab
set ts=4

" key mapping
nnoremap <Space>w :<C-u>write<CR>
nnoremap <Space>q :<C-u>quit<CR>
nnoremap <Space>Q :<C-u>quit!<CR>
nnoremap <Nul> <ESC>
" buffer
nnoremap <Space>h :<C-u>bp<CR>
nnoremap <Space>j :<C-u>bn<CR>
nnoremap <Space>d :<C-u>bd<CR>

imap <C-@> <C-[>

"""""
" Japanese Settins by ずんWik
"
" 文字コードの自動認識
"""""
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  " iconvがJISX0213に対応しているかをチェック
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  " 定数を処分
  unlet s:enc_euc
  unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" 改行コードの自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif

"""""
" Highlight Settings
"""""
syntax on
hi Comment ctermfg=Red
hi Function ctermfg=cyan


"""""
" 編集時用設定 

"""""
set helpfile=$VIMRUNTIME/doc/help.txt
"set complete=+k 不正な文字といわれるのでコメントアウト。
if has("autocmd")
    " PHPのときは辞書を使う
    autocmd FileType php :set dictionary+=~/.vim/dict/php.dict
        "\ dictionary+=~/.vim/dict/php_constants.dict
    autocmd FileType ctp :set dictionary+=~/.vim/dict/php.dict
        "\ dictionary+=~/.vim/dict/php_constants.dict
    autocmd FileType rb :set dictionary+=~/.vim/dict/ruby.dict
    autocmd FileType pl :set dictionary+=~/.vim/dict/perl.dict
    autocmd FileType pm :set dictionary+=~/.vim/dict/perl.dict
    
    autocmd FileType html setlocal ts=2 sw=2
    autocmd FileType smarty setlocal ts=2 sw=2
    autocmd FileType make setlocal nomodeline noexpandtab
    autocmd FileType yaml setlocal ts=2 sw=2
    autocmd FileType css setlocal ts=2 sw=2
    autocmd FileType javascript setlocal ts=2 sw=2
    autocmd FileType python setlocal ts=2 sw=2

    autocmd BufNewFile *.php 0r ~/.vim/skeleton/php.skel
    autocmd BufNewFile *.py 0r ~/.vim/skeleton/python.skel
    autocmd BufNewFile *.rb 0r ~/.vim/skeleton/ruby.skel
    autocmd BufNewFile *.pl 0r ~/.vim/skeleton/perl.skel
    autocmd BufNewFile *.html 0r ~/.vim/skeleton/html.skel
    autocmd BufNewFile *.tpl 0r ~/.vim/skeleton/html.skel

    " バッファの。。。なんかよくわからんけど追加。あとで。
    autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
    autocmd Filetype *
                \   if &omnifunc == "" |
                \           setlocal omnifunc=syntaxcomplete#Complete |
                \   endif

endif
" ,e で編集中のファイルタイプを判別して自動的にCLIの実行をしてくれる。
nmap ,e :execute '!' &ft ' %'<CR>
" yankringの割り当て変更
if has("viminfo")
    " yankrignによるviminfoの編集の問題らしい。こうしておかないと、yankringにおこられる。
    set vi^=!
endif
nmap ,y :YRShow<CR>


"""""
" 上下キーで実行 or Lint
"""""

autocmd filetype php :setl makeprg=php\ -l\ %\ 
autocmd filetype php :setl errorformat=%m\ in\ %f\ on\ line\ %l
autocmd filetype php :setl shellpipe=2>&1\ >
autocmd FileType php :nmap <up>   <esc>:w<cr>:!/usr/bin/env php %<cr>
autocmd FileType php :nmap <down> <esc>:w<cr>:make<cr><cr>
autocmd FileType php :nmap ,l     <esc>:w<cr>:make<cr><cr>
let errormarker_errortext = "->"

autocmd FileType cpp :nmap <up>   <esc>:w<cr>:!g++ % && ./a.out<cr>

autocmd FileType c :nmap <up>   <esc>:w<cr>:!gcc % && ./a.out<cr>

autocmd FileType perl  :nmap <up>   <esc>:w<cr>:!/usr/bin/env perl %<cr>
autocmd FileType perl  :nmap <down> <esc>:w<cr>:!/usr/bin/env perl -cw %<cr>

autocmd FileType ruby  :nmap <up>   <esc>:w<cr>:!/usr/bin/env ruby %<cr>
autocmd FileType ruby  :nmap <down> <esc>:w<cr>:!/usr/bin/env ruby -c %<cr>

autocmd FileType python :nmap <up>  <esc>:w<cr>:!/usr/bin/env python %<cr>

" 拡張子がctpだったらphpと認識
augroup filetypedetect
    au! BufRead,BufNewFile *.ctp setfiletype php
    au! BufRead,BufNewFile *.xul setfiletype xul
    au! BufRead,BufNewFile *.jsm setfiletype javascript
augroup END

let nohl_xul_atts = 1

"""""
" mini buffer explorer プラグイン用設定
"""""
"let g:miniBufExplMapWindowNavVim=1 "hjklで移動
"let g:miniBufExplSplitBelow=0  " Put new window above
"let g:miniBufExplMapWindowNavArrows=1
"let g:miniBufExplMapCTabSwitchBufs=1
"let g:miniBufExplModSelTarget=1 
"let g:miniBufExplSplitToEdge=1


"""""
" Add Functions
"""""

" GetB
" カーソル上の文字のバイナリコードを表示してくれる。
"""""
function! GetB()
  let c = matchstr(getline('.'), '.', col('.') - 1)
  let c = iconv(c, &enc, &fenc)
  return String2Hex(c)
endfunction
" :help eval-examples
" The function Nr2Hex() returns the Hex string of a number.
func! Nr2Hex(nr)
  let n = a:nr
  let r = ""
  while n
    let r = '0123456789ABCDEF'[n % 16] . r
    let n = n / 16
  endwhile
  return r
endfunc
" The function String2Hex() converts each character in a string to a two
" character Hex string.
func! String2Hex(str)
  let out = ''
  let ix = 0
  while ix < strlen(a:str)
    let out = out . Nr2Hex(char2nr(a:str[ix]))
    let ix = ix + 1
  endwhile
  return out
endfunc

" /GetB
"""""

""""
" buftabs
"バッファタブにパスを省略してファイル名のみ表示する(buftabs.vim)
let g:buftabs_only_basename=1
"バッファタブをステータスライン内に表示する
let g:buftabs_in_statusline=1


" 全角スペース、末尾の半角スペース、タブを色づけする
if has("syntax")
    syntax on
    function! ActivateInvisibleIndicator()
        syntax match InvisibleJISX0208Space "　" display containedin=ALL
        highlight InvisibleJISX0208Space term=underline ctermbg=Blue guifg=#999999 gui=underline
        syntax match InvisibleTrailedSpace "[ ]\+$" display containedin=ALL
        highlight InvisibleTrailedSpace term=underline ctermbg=Red guifg=#FF5555 gui=underline
        syntax match InvisibleTab "\t" display containedin=ALL
        highlight InvisibleTab term=underline ctermbg=Cyan guibg=#555555
    endf

    augroup invisible
        autocmd! invisible
        autocmd BufNew,BufRead * call ActivateInvisibleIndicator()
    augroup END
endif


""Tab文字も区別されずにハイライトされるので、区別したいときはTab文字の表示を別に
""設定する必要がある。
"function! SOLSpaceHilight()
"    "syntax match SOLSpace "^\s\+" display containedin=ALL
"    "highlight SOLSpace term=underline ctermbg=Gray
"endf
""全角スペースをハイライトさせる。
"function! JISX0208SpaceHilight()
"    syntax match JISX0208Space "　" display containedin=ALL
"    highlight JISX0208Space term=underline ctermbg=LightCyan
"endf
""syntaxの有無をチェックし、新規バッファと新規読み込み時にハイライトさせる
"if has("syntax")
"    syntax on
"        augroup invisible
"        autocmd! invisible
"        autocmd BufNew,BufRead * call SOLSpaceHilight()
"        autocmd BufNew,BufRead * call JISX0208SpaceHilight()
"    augroup END
"endif
"
"
""特殊文字(SpecialKey)の見える化。listcharsはlcsでも設定可能。
""trailは行末スペース。
"set list
"set listchars=tab:^_,trail:-,nbsp:%,extends:>,precedes:<


" outputzの設定を読み込む
" source ~/.outputz


if &term == "xterm-color"
    set t_kb=
    fixdel
endif
