# .bashrc

export GPG_TTY=$(tty)
export LOG_DATE="date +[%Y-%d-%m]"
export LOG_TIME="date +[%T]"

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Source my snippets
bsnips=$(find $HOME/.config/bash/*.bash)
for snip in $bsnips; do
    if . $snip; then
        echo "[INFO] $($LOG_DATE) $($LOG_TIME) $snip has been sourced." >> ${HOME}/.log/bashrc.log
    else
        echo "[ERROR] $($LOG_DATE) $($LOG_TIME) $snip could not be sourced." >> ${HOME}/.log/bashrc.log
    fi
done

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

# directory listing options
export LS_OPTIONS='--color=auto'
eval "`dircolors`"
alias ls='ls $LS_OPTIONS'

