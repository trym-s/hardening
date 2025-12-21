#!/bin/bash

# Configure maxsequence
echo "Configuring maxsequence..."

if grep -qi '^maxsequence\s*=' /etc/security/pwquality.conf 2>/dev/null; then
    sed -i 's/^maxsequence\s*=.*/maxsequence = 3/' /etc/security/pwquality.conf
elif grep -qi '^#\s*maxsequence\s*=' /etc/security/pwquality.conf 2>/dev/null; then
    sed -i 's/^#\s*maxsequence\s*=.*/maxsequence = 3/' /etc/security/pwquality.conf
else
    echo "maxsequence = 3" >> /etc/security/pwquality.conf
fi

echo "SUCCESS: maxsequence set to 3"
