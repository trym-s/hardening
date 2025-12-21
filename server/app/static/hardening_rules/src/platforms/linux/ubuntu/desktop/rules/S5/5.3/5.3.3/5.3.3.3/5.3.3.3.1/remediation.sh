#!/bin/bash

# Configure password history remember
echo "Configuring password history..."

if [ ! -f /etc/security/pwhistory.conf ]; then
    touch /etc/security/pwhistory.conf
fi

if grep -qi '^remember\s*=' /etc/security/pwhistory.conf 2>/dev/null; then
    sed -i 's/^remember\s*=.*/remember = 24/' /etc/security/pwhistory.conf
else
    echo "remember = 24" >> /etc/security/pwhistory.conf
fi

echo "SUCCESS: Password history set to remember 24 passwords"
