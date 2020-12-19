#!/usr/bin/env sh

gitclone() {
    git clone --recurse --depth=1 --single-branch "$1" 2> /dev/null
}

gitclone https://github.com/Jorengarenar/joren.sh.d.git
gitclone https://github.com/Jorengarenar/libProgWrap.git

if [ -z "$(ldconfig -p | grep 'jcbc')" ]; then
    if [ ! -e "$XDG_LIB_DIR/c/libjcbc.so" ]; then
        gitclone https://github.com/Jorengarenar/libJCBC.git
    fi
fi