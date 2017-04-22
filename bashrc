# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

# directory listing options
export LS_OPTIONS='--color=auto'
eval "`dircolors`"
alias ls='ls $LS_OPTIONS'

# Escape variable
ESC=$(printf "\e")
# Color variables for prompt
TBOLD="\[${ESC}[1m\]"
TNORM="\[${ESC}[0m\]"
fg_R="\[${ESC}[31m\]"
fg_G="\[${ESC}[32m\]"
fg_Y="\[${ESC}[33m\]"
fg_B="\[${ESC}[34m\]"
fg_M="\[${ESC}[35m\]"
fg_C="\[${ESC}[36m\]"
fg_W="\[${ESC}[37m\]"

# Set prompt

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
    PROMPT_COMMAND="console_last_status; $TERMTITLE"
else
    PROMPT_COMMAND="emu_last_status; $TERMTITLE"
fi

PS1="${TNORM}${fg_R}·${fg_M}·${fg_G}· ${TNORM}"

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


# The colors Duke, the colors!
# Apply colors defined in ~/.Xresources to linux console
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

