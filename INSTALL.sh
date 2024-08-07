#!/usr/bin/env sh


[ "$1" = "-f" ] && gf_force=1 || gf_force=0

if [ -x "$(command -v git)" ]; then
    echo "Updating Git submodules"
    git submodule update --init --recursive --remote
fi

. extern/pathmunge.sh/pathmunge.sh
. config/profile.d/20-variables.sh
. config/user-dirs.dirs


abspath () (
    if [ -d "$1" ]; then
        cd "$1" && pwd
    elif [ -f "$1" ]; then
        case "$1" in
            /*)  echo "$1" ;;
            */*) echo "$(cd "$(dirname "$1")" && pwd)/$(basename "$1")" ;;
            *)   echo "$PWD/$1" ;;
        esac
    else
        >&2 echo "abspath() is unable to operate on not exisiting paths"
    fi
)

install () (
    src="$1"
    op="$2"
    dest="$3"

    action=
    case "$op" in
        '@') action="ln -sf" ;;
        '%') action="cp -r" ;;
        *) return ;;
    esac


    if [ "$gf_force" -eq 1 ] && [ -e "$dest" ]; then
        old="$HOME/dotfiles.old/$dest"
        if mkdir -p "$(dirname "$old")"; then
            mv "$dest" "$old" && echo "Moved file '$dest' to directory '$old'"
        fi
    fi

    if [ ! -e "$dest" ]; then
        mkdir -p "$(dirname "$dest")"
        sh -c "$action '$(abspath "$src")' '$dest'"
    fi
)

install_bulk () (
    prefix="$1"
    while read -r src op dest; do
        [ -z "$src" ] && continue
        [ -z "$op" ] && op='@'
        [ -z "$dest" ] && dest="$(basename "$src")"
        install "$src" "$op" "$prefix/$dest"
    done
)


[ ! -s "$HOME"/.profile ] && cat > "$HOME"/.profile << 'EOF'
# ~/.profile

for profile in "$HOME"/.local/config/profile.d/*.sh; do
    . "$profile"
done

export SHELL="$(command -v myshell.sh)"

# ------------------------------------------------------------------------------
EOF


if [ "$XDG_CONFIG_HOME" != "$HOME"/.config ]; then
    mkdir -p "$XDG_CONFIG_HOME"
    install  "$XDG_CONFIG_HOME"  @  "$HOME"/.config
fi

install  templates/  @  "$XDG_TEMPLATES_DIR"

install_bulk "$XDG_CONFIG_HOME" << EOL

    config/aerc/
    config/bash/
    config/ccache/
    config/chktexrc  @  .chktexrc
    config/clangd/
    config/commafeed.yml
    config/ctags/
    config/deno.json
    config/dosbox/
    config/feh/
    config/fontconfig/
    config/gdb/
    config/git/
    config/grip/
    config/gtk-3.0/settings.ini  @  gtk-3.0/settings.ini
    config/htop/
    config/i3/
    config/lesskey
    config/mpv/
    config/mutt/
    config/npm/
    config/nvim/
    config/OpenSCAD/
    config/polybar/
    config/powershell/
    config/profile.d/
    config/python/
    config/qt5ct/
    config/ranger/
    config/readline/
    config/sh/
    config/shellcheckrc
    config/sqlite3/
    config/ssh/
    config/stalonetrayrc
    config/sway/
    config/systemd/
    config/telnetrc  @  .telnetrc
    config/tmux/
    config/transmission.json  %  transmission-daemon/settings.json
    config/uncrustify/
    config/user-dirs.conf
    config/user-dirs.dirs
    config/vale/
    config/vim/
    config/waybar/
    config/X11/
    config/zathura/
    config/zsh/

EOL

install_bulk "$XDG_DATA_HOME" << EOL

    config/vale/config/  @  vale/styles/config

    config/firefox/user.js          @  firefox/user.js
    config/firefox/userChrome.css   @  firefox/chrome/userChrome.css
    config/firefox/userContent.css  @  firefox/chrome/userContent.css

    misc/desktop_entries/  @  applications/custom

    fonts/  @  fonts

EOL

chmod -R -w \
    config/htop/htoprc \
    config/OpenSCAD/OpenSCAD.conf \
    config/qt5ct


# xdg_wrapper.sh {{{
sed -n -e 's/^#~ //p' "bin/xdg_wrapper.sh" | while IFS= read -r exe; do
    if [ -x "$(command -v "$exe")" ]; then
        install  bin/xdg_wrapper.sh  @  "$HOME/.local/opt/xdg.wrappers/bin/$exe"
    fi
done
# }}}

# DCONF_PROFILE {{{
#   prevents creation of ~/.dconf
DCONF_PROFILE="$XDG_CONFIG_HOME/dconf/user"
mkdir -p "$(dirname "$DCONF_PROFILE")" && \
    touch "$DCONF_PROFILE"
# }}}
