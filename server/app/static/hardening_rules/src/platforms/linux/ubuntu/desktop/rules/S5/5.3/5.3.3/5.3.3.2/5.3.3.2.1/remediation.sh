#!/bin/bash

# Configure password changed characters
echo "Configuring difok..."

if grep -qi '^difok\s*=' /etc/security/pwquality.conf 2>/dev/null; then
    sed -i 's/^difok\s*=.*/difok = 2/' /etc/security/pwquality.conf
elif grep -qi '^#\s*difok\s*=' /etc/security/pwquality.conf 2>/dev/null; then
    sed -i 's/^#\s*difok\s*=.*/difok = 2/' /etc/security/pwquality.conf
else
    echo "difok = 2" >> /etc/security/pwquality.conf
fi

echo "SUCCESS: difok set to 2"
