# dotfiles

## セットアップ

```bash
cd /path/to
git clone https://github.com/marucc/dotfiles.git
cd dotfiles
git submodule init
git submodule update
./setup.sh
```

## vim

初回起動時に vim-plug とプラグインが自動インストールされる。

手動でインストールする場合:
```
vim
:PlugInstall
```
