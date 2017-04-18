# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# Source secrets files
SECRETS_DIR="${HOME}/.config/secrets"
for file in $(ls $SECRETS_DIR); do
    if [ -f $SECRETS_DIR/$file ]; then
        . $SECRETS_DIR/$file
    fi
done

# User specific environment and startup programs
export visual=vim
export EDITOR=vim
export PATH=$PATH:$HOME/bin:$HOME/.local/bin:$HOME/.local/scripts/bin
# XDG variables
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

# Change default vimrc location
export VIMINIT="so $XDG_CONFIG_HOME/vim/vimrc"

#if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
#    exec startx
#fi
