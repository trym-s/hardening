#!/bin/bash

# CIS 5.4.3.1 - Ensure nologin is not listed in /etc/shells
# Remove nologin from /etc/shells

echo "Removing nologin from /etc/shells..."

# Backup /etc/shells
cp /etc/shells /etc/shells.bak.$(date +%s)

# Remove lines containing nologin
sed -i '/\/nologin/d' /etc/shells

# Verify
if grep -Ps '^\h*([^#\n\r]+)?\/nologin\b' /etc/shells > /dev/null; then
    echo "FAIL: Could not remove nologin from /etc/shells"
    return 1
else
    echo "SUCCESS: nologin removed from /etc/shells"
fi
