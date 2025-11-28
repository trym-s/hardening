#!/bin/bash
if gsettings get org.gnome.login-screen banner-message-text | grep -q "Authorized users only"; then
    echo "banner-message-text is configured"
    exit 0
else
    echo "banner-message-text is NOT configured"
    exit 1
fi
