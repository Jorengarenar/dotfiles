# BASHRC #

# COMPLETION {{{1

# Enable programmable completion features
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# Better autocompletion (like in zsh), but use Shift-Tab
bind '"\e[Z":menu-complete'

# Enable extended globbing
shopt -s extglob

# Magic space
bind Space:magic-space

# HISTORY {{{1

# 'HISTFILE' defined in _XDG

# For setting history length see HISTSIZE and HISTFILESIZE
HISTSIZE=500
HISTFILESIZE=500

# Avoid duplicates
export HISTCONTROL=ignoreboth

# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend

# OTHER {{{1

# Use Vi mode
set -o vi

# Source shells environment configs
source $XDG_CONFIG_HOME/shell/shrc

# PROMPT
PS1='\[\e[1m\]\u@\h:\[\033[90m\]\w\[\033[0m\]\[\033[1m\]\$\[\e[0m\] '

# Set window title to "command | user@host:dir"
case "$TERM" in
    xterm*|rxvt*|screen*)
        PS1="\[\e]0;\u@\h:\w\a\]$PS1"
        ;;
    *)
        ;;
esac

# vim: ft=bash fdm=marker fen
