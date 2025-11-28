#!/bin/bash
if gsettings get org.gnome.login-screen banner-message-enable | grep -q "true"; then
    echo "banner-message-enable is true"
    exit 0
else
    echo "banner-message-enable is NOT true"
    exit 1
fi
