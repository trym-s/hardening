#!/bin/bash

# CIS 5.4.3.1 - Ensure nologin is not listed in /etc/shells
# Check that nologin is not in /etc/shells

echo "Checking if nologin is listed in /etc/shells..."

nologin_entry=$(grep -Ps '^\h*([^#\n\r]+)?\/nologin\b' /etc/shells)

if [ -z "$nologin_entry" ]; then
    echo "PASS: nologin is not listed in /etc/shells"
    exit 0
else
    echo "FAIL: nologin is listed in /etc/shells:"
    echo "$nologin_entry"
    exit 1
fi
