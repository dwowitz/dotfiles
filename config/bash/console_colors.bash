#! /bin/bash
#
# console_colors.bash
# Copyright (C) 2017 Danny Berkowitz <dwowitz@gmail.com>
#
# Distributed under terms of the MIT license.
#
# Description:
# Apply terminal colors defines in $HOME/.Xresources to the linyx console.

if [ "$TERM" = "linux" ]; then
    ORIGIFS=$IFS
    IFS=$'\n'
    for i in $(grep "\*\.color" ~/.Xresources)
    do
        Cnumd=$( echo $i | awk -F: '{ print $1 }' | tr -d '*.color' )
        Cnumh=$( echo "obase=16; $Cnumd" | bc )
        Eseq=$( echo $i | awk '{ print $2 }' | sed "s/\#/\\\e\]P${Cnumh}/g" )
        printf "$Eseq"
    done
    IFS=$ORIGIFS
    # get rid of artifacts
    clear
fi

