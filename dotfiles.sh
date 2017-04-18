#!/bin/bash

### Variables ###
relscriptdir=$(dirname $0)     # relative path of directory conaining this script
scriptdir=`cd $relscriptdir && pwd`
today=`date +"%m-%d-%Y_%s"`    # date mm-dd-yyyy
dir="$HOME/dotfiles"           # dotfiles directory
olddir="$HOME/dotfiles.$today" # old dotfiles backup directory
files=`ls $scriptdir`          # list of files/folders to symlink
dotignored=`cat ${scriptdir}/.dotignore | egrep -v "^#"`
##########

# Files in $scriptdir excluding $dotignored
# The resulting list will be symlinked to $HOME
for ignore in $dotignored; do
    dotfiles=`echo $files | sed "s/\b$ignore\b//g"`
done

# move any existing dotfiles in ~/ to $olddir directory
echo "Backing up current dotfiles to $olddir..."
mkdir -p $olddir
for file in $dotfiles; do
    if [ -e ~/.$file ] && [ ! -L ~/.$file ]; then
        echo "Moving \".$file\" from \"$HOME\" to \"$olddir\""
        mv $HOME/.$file $olddir/.$file
    fi
done

# symlink dotfiles to $HOME
for file in $dotfiles; do
    echo "Creating symlink to \"$file\" in home directory."
    ln -sf $scriptdir/$file $HOME/.$file
done

# install vim plugins
if [ ! ~/.vim/autoload/plug.vim ]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    vim +PlugInstall +qall
    sleep 1
else
    vim +PlugUpdate +qall
fi

#Done
echo "Dotfiles have finished installing."
