# dotfiles

```
cd /path/to
git clone dotfiles.git
cd dotfiles
./setup.sh
```

## vim


NeoBundle 'taglist.vim' で ctags が必要
```
sudo apt-get install ctags
```

```
cd /path/to/dotfiles
git submodule init
git submodule update
vim
```

vim command
```
:NeoBundleInstall
```
