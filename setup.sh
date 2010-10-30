#!/bin/sh
cd `dirname $0`
DOTFILES=`pwd`

ln -s $DOTFILES/vim/.vim $HOME/.vim
ln -s $DOTFILES/vim/.vimrc $HOME/.vimrc
ln -s $DOTFILES/zsh/.zshrc $HOME/.zshrc
ln -s $DOTFILES/zsh/.dircolors $HOME/.dircolors
ln -s $DOTFILES/zsh/.zshrc.d/ $HOME/.zshrc.d
ln -s $DOTFILES/screen/.screenrc $HOME/.screenrc
touch $HOME/.outputz

cd -
