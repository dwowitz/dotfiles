#!/usr/bin/echo "Source me for a good time." .
#
# aliases.bash
# Copyright (C) 2017 Danny Berkowitz <dwowitz@gmail.com>
#
# Distributed under terms of the MIT license.
#

# Aliases
alias mkdir='mkdir -p'
alias vi='vim'
alias ll='ls -la'
alias locate='sudo updatedb && locate'

# Suckless aliases for packages installed using my PKGBUILDs
SLS="dwm st"
for sl in $SLS
do
    alias $sl="${sl}_${USER}"
done

