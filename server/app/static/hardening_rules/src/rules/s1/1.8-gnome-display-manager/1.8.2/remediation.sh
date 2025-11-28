#!/bin/bash
gsettings set org.gnome.login-screen banner-message-text "Authorized users only. All activity may be monitored and reported."
dconf update
