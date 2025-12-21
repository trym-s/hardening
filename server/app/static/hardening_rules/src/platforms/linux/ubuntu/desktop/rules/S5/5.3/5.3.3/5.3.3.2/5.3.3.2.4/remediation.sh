#!/bin/bash

# Configure maxrepeat
echo "Configuring maxrepeat..."

if grep -qi '^maxrepeat\s*=' /etc/security/pwquality.conf 2>/dev/null; then
    sed -i 's/^maxrepeat\s*=.*/maxrepeat = 3/' /etc/security/pwquality.conf
elif grep -qi '^#\s*maxrepeat\s*=' /etc/security/pwquality.conf 2>/dev/null; then
    sed -i 's/^#\s*maxrepeat\s*=.*/maxrepeat = 3/' /etc/security/pwquality.conf
else
    echo "maxrepeat = 3" >> /etc/security/pwquality.conf
fi

echo "SUCCESS: maxrepeat set to 3"
