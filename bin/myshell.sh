#!/usr/bin/env sh

if [ "$#" -eq 0 ]; then
    while [ -x "$(command -v tmux)" ]; do
        [ -n "${TMUX+x}" ] && break
        [ -z "$DISPLAY" ] && break
        # [ -n "$SSH_CLIENT" ] && break

        # shellcheck disable=SC2155
        export SHELL="$(command -v "$0")"

        # shellcheck disable=SC2093
        exec tmux -S "$XDG_RUNTIME_DIR"/tmux $(
            if ps -ef | grep -v grep | grep -q tmux; then
                echo attach \; new-session
            else
                echo "-f ${TMUX_CONF:-$XDG_CONFIG_HOME/tmux/tmux.conf}"
            fi
        )
    done
fi

e () {
    sh="$1" && shift
    bin="$(command -v "$sh")"
    if [ -x "$bin" ]; then
        export SHELL="$bin"
        exec "$sh" "$@"
    fi
}

e "$MYSHELL" "$@"
e bash --rcfile "$XDG_CONFIG_HOME"/bash/bashrc "$@"
e zsh "$@"
e ksh "$@"
e tcsh "$@"
e fish "$@"

exec sh "$@"
