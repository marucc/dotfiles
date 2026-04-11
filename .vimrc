" .vimrc file
"
" Maintainer:   Tomoyuki MARUTA <tomoyuki.maruta@gmail.com>
" https://github.com/marucc/dotfiles

set nocompatible

" vim-plug（未インストール時は自動取得）
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'lambdalisue/fern.vim'
call plug#end()

" fern.vim
let g:fern#default_hidden = 1
nmap <silent> <C-t> :Fern . -drawer -toggle<CR>

function! s:fern_init() abort
  nmap <buffer> <BS> <Plug>(fern-action-leave)
  nmap <buffer> <CR> <Plug>(fern-action-open-or-enter)
endfunction

augroup fern-custom
  autocmd! *
  autocmd FileType fern call s:fern_init()
augroup END


" Basic Settings
let mapleader = ","
set scrolloff=3
set textwidth=0
set nobackup
set autoread
set noswapfile
set hidden
set backspace=indent,eol,start
set formatoptions=lmoq
set vb t_vb=
set browsedir=buffer
set whichwrap=b,s,h,l,<,>,[,]
set showcmd
set showmode
set mouse=a

" Status line
set laststatus=2
set ruler
set title
set statusline=%<[%n]%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P
set wildmode=list:longest

" Indent
set autoindent smartindent
set expandtab
set tabstop=4 shiftwidth=4 softtabstop=0

if has("autocmd")
  filetype plugin indent on
  autocmd FileType javascript setlocal sw=2 sts=2 ts=2 et
  autocmd FileType typescript setlocal sw=2 sts=2 ts=2 et
  autocmd FileType typescriptreact setlocal sw=2 sts=2 ts=2 et
  autocmd FileType ruby       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType haml       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType slim       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType yaml       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType vim        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType html       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType css        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType json       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType vue        setlocal sw=2 sts=2 ts=2 et
endif

" View
set showmatch
set number
set list
set listchars=tab:^_,trail:-,nbsp:%,extends:>,precedes:<
set display=uhex
if exists('ambiwidth')
  set ambiwidth=double
endif
augroup cch
  autocmd! cch
  autocmd WinLeave * set nocursorline
  autocmd WinEnter,BufRead * set cursorline
augroup END
hi clear CursorLine
hi CursorLine gui=underline
highlight CursorLine ctermbg=black guibg=black
set lazyredraw
set ttyfast

" Complete
set wildmenu
set wildchar=<tab>
set history=1000
set complete+=k
cnoremap <C-p> <Up>
cnoremap <Up>  <C-p>
cnoremap <C-n> <Down>
cnoremap <Down>  <C-n>

" Search
set wrapscan
set ignorecase
set smartcase
set incsearch
set hlsearch
nmap <ESC><ESC> ;nohlsearch<CR><ESC>

" Color
if has("syntax")
  syntax on

  highlight Pmenu ctermfg=Black ctermbg=Grey
  highlight PmenuSel ctermfg=Black ctermbg=Yellow
  highlight PmenuSbar ctermbg=Cyan

  highlight DiffAdd    term=bold ctermfg=White ctermbg=Red
  highlight DiffChange term=bold ctermfg=Black ctermbg=Cyan
  highlight DiffDelete term=bold cterm=bold ctermfg=Red ctermbg=Blue
  highlight DiffText   term=reverse cterm=bold ctermfg=Black ctermbg=Green
endif

" Encoding
set ffs=unix,dos,mac
set encoding=utf-8

set suffixes=.pyc,.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

command! Cp932 edit ++enc=cp932
command! Eucjp edit ++enc=euc-jp
command! Iso2022jp edit ++enc=iso-2022-jp
command! Utf8 edit ++enc=utf-8
command! Jis Iso2022jp
command! Sjis Cp932

" Move
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif
vnoremap v $h
