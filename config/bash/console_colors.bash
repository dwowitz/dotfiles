#! /bin/bash
#
# console_colors.bash
# Copyright (C) 2017 Danny Berkowitz <dwowitz@gmail.com>
#
# Distributed under terms of the MIT license.
#
# Description:
# Apply terminal colors defined in $HOME/.Xresources to the linux console.

if [ "$TERM" = "linux" ]; then
    ORIGIFS=$IFS
    IFS=$'\n'
    for i in $(grep "\*\.color" $XDG_CONFIG_HOME/X11/Xresources)
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

