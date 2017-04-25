#! /bin/bash
#
# ps1.bash
# Copyright (C) 2017 Danny Berkowitz <dwowitz@gmail.com>
#
# Distributed under terms of the MIT license.
#

# Source file containing color variables.
DIR=$(cd -P $(dirname $BASH_SOURCE[0]) && pwd)

. ${DIR}/colors.bash

# Set prompt
PS1=''

if [ $UID == "0" ]; then
    PROMPT_STRING="${TNORM}${fg_R}·${fg_M}·${fg_G}· \# ${TNORM}"
else
    PROMPT_STRING="${TNORM}${fg_R}·${fg_M}·${fg_G}· \$ ${TNORM}"
fi

if [ -n "$SSH_CLIENT" ]; then
    ISSSH="${TNORM}${fg_M}[ ${fg_Y}ssh://\u@\h${fg_M} ]${TNORM}"
    PS1+="$ISSSH"
fi

PS1+="${PROMPT_STRING}"

