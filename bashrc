# .bashrc

export GPG_TTY=$(tty)

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Source my snippets
bsnips=$(find $HOME/.config/bash/*.bash)
for snip in $bsnips; do
    . $snip
done

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

# directory listing options
export LS_OPTIONS='--color=auto'
eval "`dircolors`"
alias ls='ls $LS_OPTIONS'

