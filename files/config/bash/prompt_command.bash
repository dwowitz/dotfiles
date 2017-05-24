#!/usr/bin/echo "Source me for a good time." .
#
# prompt_command.bash
# Copyright (C) 2017 Danny Berkowitz <dwowitz@gmail.com>
#
# Distributed under terms of the MIT license.
#


## Display status of last executed command.
# Do not use unicode glyphs for linux console
console_last_status()
{
    case "$?" in
        0)
            printf "\033[32m+++\e[1m\n"
            ;;
        1)
            printf "\033[31mxxx\e[1m\n"
            ;;
        *)
            printf "\033[33m???\e[1m\n"
            ;;
    esac
}
# Use unicode glyphs in terminal emulator
emu_last_status()
{
    case "$?" in
        0)
            printf "\033[32m\e[1m\n"
            ;;
        1)
            printf "\033[31m\e[1m\n"
            ;;
        *)
            printf "\033[33m\e[1m\n"
            ;;
    esac
}

## Update title bar with user and location info
TERMTITLE='printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'

if [ "$TERM" = "linux" ]; then
    PROMPT_COMMAND="history -a; console_last_status; $TERMTITLE"
else
    PROMPT_COMMAND="history -a; emu_last_status; $TERMTITLE"
fi

