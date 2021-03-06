#!/usr/bin/env sh

# Init {{{1

gitclone() {
    cd ${TMPDIR:-/tmp}
    rm -rf   dotfiles_${USER}_deps
    mkdir -p dotfiles_${USER}_deps
    cd       dotfiles_${USER}_deps
    git clone --recurse --depth=1 --single-branch "$1" 2> /dev/null
}

force_flag=$1
DIR="$(dirname $(realpath $0))"

. $DIR/env/variables

chmod -R +x bin/

# foo FUNCTION {{{

# 1st argument - command
# 2nd argument - file in dotfiles dir
# 3rd argument - location of link
# 4th argument - permissions
foo() {

    if [ "$force_flag" = "-f" ] && [ -e "$3" ]; then
        mkdir -p $HOME/dotfiles.old/
        mv "$3" "$HOME/dotfiles.old/"
        echo "Moved file $3 to directory $HOME/dotfiles.old/"
    fi

    if [ ! -e $3 ]; then
        mkdir -p "$(dirname $3)"
        $1 $DIR/$2 $3
    fi

    [ -n "$4" ] && chmod "$4" "$3"

}

linking() {
    foo "ln -sf" $@
}

copying() {
    foo "cp" $@
}

# }}}

# MAIN {{{1

linking  env/pam           $HOME/.pam_environment

linking  aerc/             $XDG_CONFIG_HOME/aerc
linking  asoundrc          $XDG_CONFIG_HOME/alsa/asoundrc
linking  bashrc            $XDG_CONFIG_HOME/bash/bashrc
linking  chktexrc          $XDG_CONFIG_HOME/.chktexrc
linking  cshrc             $XDG_CONFIG_HOME/csh/.cshrc  # thanks to wrapper
linking  dosbox.conf       $XDG_CONFIG_HOME/dosbox/dosbox.conf
linking  env               $XDG_CONFIG_HOME/env
linking  feh/              $XDG_CONFIG_HOME/feh
linking  fish/             $XDG_CONFIG_HOME/fish
linking  gdbinit           $XDG_CONFIG_HOME/gdb/init
linking  git/              $XDG_CONFIG_HOME/git
linking  htoprc            $XDG_CONFIG_HOME/htop/htoprc        -w
linking  i3/               $XDG_CONFIG_HOME/i3
linking  mimeapps.list     $XDG_CONFIG_HOME/mimeapps.list
linking  mpv/              $XDG_CONFIG_HOME/mpv
linking  muttrc            $XDG_CONFIG_HOME/mutt/muttrc
linking  myclirc           $XDG_CONFIG_HOME/mycli/myclirc
linking  newsboat/config   $XDG_CONFIG_HOME/newsboat/config
linking  ranger.conf       $XDG_CONFIG_HOME/ranger/rc.conf
linking  Renviron          $XDG_CONFIG_HOME/R/Renviron
linking  shell/            $XDG_CONFIG_HOME/shell
linking  ssh_config        $XDG_CONFIG_HOME/ssh/config
linking  tmux.conf         $XDG_CONFIG_HOME/tmux/tmux.conf
linking  user-dirs.dirs    $XDG_CONFIG_HOME/user-dirs.dirs
linking  vim/              $XDG_CONFIG_HOME/vim
linking  X11/              $XDG_CONFIG_HOME/X11
linking  zathurarc         $XDG_CONFIG_HOME/zathura/zathurarc

linking  ccache.config     $CCACHE_CONFIGPATH
linking  gpg-agent.conf    $GNUPGHOME/gpg-agent.conf
linking  grip.py           $GRIPHOME/grip.py
linking  gtkrc-2.0         ${GTK2_RC_FILES%:*} # link only real gtkrc, omit the one from GTK_THEME
linking  inputrc           $INPUTRC
linking  mailcap           $MAILCAP
linking  npmrc             $NPM_CONFIG_USERCONFIG
linking  python_config.py  $PYTHONSTARTUP
linking  uncrustify/       $(dirname $UNCRUSTIFY_CONFIG)
linking  zshrc             $ZDOTDIR/.zshrc

linking  app.desktop.d/    $XDG_DATA_HOME/applications/custom
linking  fonts/            $XDG_DATA_HOME/fonts
linking  themes/           $XDG_DATA_HOME/themes

linking  bin/scripts/      $XDG_LOCAL_HOME/bin/scripts
linking  bin/wrappers/     $XDG_LOCAL_HOME/bin/wrappers

linking  firefox/user.js         $XDG_DATA_HOME/firefox/user.js
linking  firefox/userContent.css $XDG_DATA_HOME/firefox/chrome/userContent.css
linking  firefox/userChrome.css  $XDG_DATA_HOME/firefox/chrome/userChrome.css

copying  spicy_settings    $XDG_CONFIG_HOME/spicy/settings # linking is nulled after each run and replcaced with copy
copying  QuiteRss.ini      $XDG_CONFIG_HOME/QuiteRss/QuiteRss.ini

# "PATCHING" {{{1

patch_dir="$XDG_LOCAL_HOME/bin/_patch"

# XDG Base Dir
# xdg_wrapper.sh {{{3
chmod u+x $DIR/_patch/xdg_base_dir/xdg_wrapper.sh

xdg_wrappers_dir="$patch_dir/xdg_wrappers"

find "$xdg_wrappers_dir" -type l -delete # clean old symlinks to wrappers

while IFS= read -r exe; do
    exe="$(echo $exe | cut -f1 -d'#')"
    [ -x "$(command -v $exe)" ] && linking  _patch/xdg_base_dir/xdg_wrapper.sh  $xdg_wrappers_dir/$exe
done < "$DIR/_patch/xdg_base_dir/wrapping.list"

# MozXDG
if [ -x "$(command -v firefox)" ]; then
    if [ "$force_flag" = "-f" ]; then
        gitclone https://github.com/Jorengarenar/MozXDG.git
        (cd $TMPDIR/dotfiles_${USER}_deps/MozXDG && make && make install)
    fi
    [ -x "$(command -v mozxdg)" ] && ln -sf "$(command -v mozxdg)" $xdg_wrappers_dir/firefox
fi

# Install /etc/profile.d/profile_xdg.sh ? {{{3

# Check if user has sudo privileges
prompt_sudo=$(sudo -nv 2>&1)
if [ $? -eq 0 ] || echo "$prompt_sudo" | grep -q '^sudo:'; then
    is_sudo=true
else
    is_sudo=false
fi

status=no
if [ ! -f /etc/profile.d/profile_xdg.sh ]; then
    if [ $is_sudo = true ]; then
        printf 'Do you wish to install root patches for XDG support for 'profile' file? [y/N] '
        read -r REPLY
        if [ "$REPLY" = "y" -o "$REPLY" = "Y" ]; then
            status=installing
        fi
    fi
else
    status=installed
fi

if [ "$status" = "installing" ]; then
    sudo ln -sf $DIR/_patch/xdg_base_dir/profile_xdg.sh /etc/profile.d/profile_xdg.sh
    sudo chmod 644 /etc/profile.d/profile_xdg.sh  # just in case
elif [ "$status" != "installed" ]; then
    linking  env/profile  $HOME/.profile
fi

# }}}3

# OTHER {{{1

mkdir -p "$(dirname $DCONF_PROFILE)" && touch "$DCONF_PROFILE" # prevents creating ~/.dconf
mkdir -p $XDG_DATA_HOME/alsa
