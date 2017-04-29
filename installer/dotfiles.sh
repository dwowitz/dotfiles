#!/usr/bin/env bash

### Variables ###
scriptdir=$(cd -P $(dirname $BASH_SOURCE[0]) && pwd) # path to this directory.
today=`date +"%m-%d-%Y_%s"`     # date mm-dd-yyyy
dir="$HOME/dotfiles"            # dotfiles directory
olddir="$HOME/dotfiles.$today"  # old dotfiles backup directory
files=$(ls ${scriptdir}/../)    # list of files/folders to symlink
dotignored=`cat ${scriptdir}/../.dotignore | egrep -v "^#"`
deps=$(grep -v "^#" ${scriptdir}/dependencies.txt) # Read dependencies into variable.
##########

# Source dotfiles ASCII banner.
. ${scriptdir}/dotbanner.sh

# Source option parser and add options.
. ${scriptdir}/../local/scripts/lib/sh/dynoptparse.sh
options+=(["install"]="Install dotfiles to ${HOME}.")
options+=(["update"]=" Pull latest files from git.")
options+=(["backup"]=" Restore dotfiles from backup.")
options+=(["restore"]="Restore dotfiles from backup. (WIP)")
options+=(["depchk"]=" Check for missing dependencies.")


# Files in $scriptdir excluding $dotignored
# The resulting list will be symlinked to $HOME
dotfiles=$(comm -23 <(echo "$files" | sort) <(echo "$dotignored" | sort))

backup()
{
    # move any existing dotfiles in ~/ to $olddir directory
    for file in $dotfiles; do
        if [ -e ~/.$file ] && [ ! -L ~/.$file ]; then
            echo "Moving \".$file\" from \"$HOME\" to \"$olddir\""
            mkdir -p $olddir && mv $HOME/.$file $olddir/.$file
        else
            echo "Nothing to back up."
        fi
    done
}

restore()
{
    echo "Shhh, i'm not real yet."
}

install()
{
    depchk
    backup
    # symlink dotfiles to $HOME
    for file in $dotfiles; do
        echo "Creating symlink \"${HOME}/.${file}\"."
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
        install
    else
        echo "Dotfiles could not be updated. I'm sorry :-("
        exit 1
    fi
}

depchk()
{
    for d in $deps; do
        if which $d &> /dev/null; then
            echo "Found $d in \$PATH."
        else
            echo "Make sure \"$d\" is in your \$PATH before installing dotfiles."
            depsfailed+=1
        fi
    done

    if [ $depsfailed -ge 1 ]; then
        #echo "You have $depsfailed missing dependencies. Go fix it!!!"
        exit 1
    fi
}

clear

dotbanner

if [ -n $@ ]; then
    parse_opts --help
else
    parse_opts $@
fi









