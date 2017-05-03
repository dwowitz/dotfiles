#!/usr/bin/env bash
#
# dotbanner.sh
# Copyright (C) 2017 Danny Berkowitz <dwowitz@gmail.com>
#
# Distributed under terms of the MIT license.
#

dotbanner()
{
    local BLUE=$(tput setaf 111)
    local RED=$(tput setaf 198)
    local BG_BLACK=$(tput setab 0)
    local BG_OTHER=$(tput setab 237)

    tput sgr0
    tput bold

    cat <<'EOF' |\
        sed "s/[[:alnum:]\.\&\`\']/${BLUE}&/g" |\
        sed "s/[|_\/\\]/${RED}&/g" |\
        sed "1s/^/$BG_BLACK/" |\
        sed "2s/^/$BG_OTHER/"
 ____________________________________________________________________________
|                                                                            |
|                                        .d8b.                               |
|                   88           .d88b.  88888    8888                       |
|                  88            8Y  Y8  'G8D'      88     .d88b.   .d00b.   |
|   .d8b.         88             88                 88     8Y  Y8   8Y  Y8   |
|   8' Yb .8     88            8888888   8888       88     88  88   88.      |
|      'G8D'    88     .d88b.    88        88       88     888888   'G88b.   |
|              88     .888888.   88        88       88     88           Y8   |
|             88      '888888'   88        88       88     88  88   88  88   |
|            88        'G88D'    88      888888   888888   'G88D'   'G88D'   |
|                                                                            |
|____________________________________________________________________________|

EOF

    tput sgr0
}



#|------| |------| |------| |------| |------| |------| |------| |------|
