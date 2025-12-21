#!/bin/bash

# Configure minimum password length
echo "Configuring minlen..."

if grep -qi '^minlen\s*=' /etc/security/pwquality.conf 2>/dev/null; then
    sed -i 's/^minlen\s*=.*/minlen = 14/' /etc/security/pwquality.conf
elif grep -qi '^#\s*minlen\s*=' /etc/security/pwquality.conf 2>/dev/null; then
    sed -i 's/^#\s*minlen\s*=.*/minlen = 14/' /etc/security/pwquality.conf
else
    echo "minlen = 14" >> /etc/security/pwquality.conf
fi

echo "SUCCESS: minlen set to 14"
