#!/usr/bin/env bash

### Variables ###
scriptdir=$(cd -P $(dirname $BASH_SOURCE[0]) && pwd) # path to this directory.
today=`date +"%m-%d-%Y_%s"`     # date mm-dd-yyyy
dir="$HOME/dotfiles"            # dotfiles directory
olddir="$HOME/dotfiles.$today"  # old dotfiles backup directory
files=$(ls ${scriptdir}/../)    # list of files/folders to symlink
dotignored=`cat ${scriptdir}/../.dotignore | egrep -v "^#"`
##########

. ${scriptdir}/../local/scripts/lib/sh/dynoptparse.sh
options+=(["install"]="Install dotfiles to ${HOME}.")
options+=(["update"]=" Pull latest files from git.")
options+=(["backup"]=" Restore dotfiles from backup.")
options+=(["restore"]="Restore dotfiles from backup. (WIP)")


# Files in $scriptdir excluding $dotignored
# The resulting list will be symlinked to $HOME
dotfiles=$(comm -23 <(echo "$files" | sort) <(echo "$dotignored" | sort))

backup()
{
    # move any existing dotfiles in ~/ to $olddir directory
    echo "Backing up current dotfiles to $olddir..."
    mkdir -p $olddir
    for file in $dotfiles; do
        if [ -e ~/.$file ] && [ ! -L ~/.$file ]; then
            echo "Moving \".$file\" from \"$HOME\" to \"$olddir\""
            mv $HOME/.$file $olddir/.$file
        fi
    done
}

restore()
{
    echo "Shhh, i'm not real yet."
}

install()
{
    backup
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
}

update()
{
    if cd ${scriptdir}../ && git pull; then
        install && exit 0
    else
        echo "Dotfiles could not be updated. I'm sorry :-("
        exit 1
    fi
}

parse_opts $@
