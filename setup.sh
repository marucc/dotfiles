#!/bin/sh
cd $(dirname $0)

# ホーム直下のdotfileをシンボリックリンク
for dotfile in .?*
do
    if [ $dotfile != '..' ] && [ $dotfile != '.git' ] && [ $dotfile != '.gitmodules' ] && [ $dotfile != '.config' ]
    then
        ln -Fis "$PWD/$dotfile" $HOME
    fi
done

# .config 以下のファイルをシンボリックリンク
if [ -d .config ]; then
    for dir in .config/*/; do
        mkdir -p "$HOME/$dir"
        for file in "$dir"*; do
            ln -Fis "$PWD/$file" "$HOME/$file"
        done
    done
fi
