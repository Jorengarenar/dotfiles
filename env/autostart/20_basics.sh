#!/usr/bin/env sh

if ! grep -Fxqs "executed_autostart" "$TMPFLAGS"; then

    # turn off Bluetooth
    if sudo -n rfkill > /dev/null 2>&1; then
        sudo rfkill block bluetooth
    fi

    # start fcitx
    [ -x "$(command -v fcitx)" ] && fcitx -d

    echo "executed_autostart" >> "$TMPFLAGS"
fi
