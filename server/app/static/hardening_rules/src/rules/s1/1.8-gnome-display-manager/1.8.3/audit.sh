#!/bin/bash
if gsettings get org.gnome.login-screen disable-user-list | grep -q "true"; then
    echo "disable-user-list is true"
    exit 0
else
    echo "disable-user-list is NOT true"
    exit 1
fi
