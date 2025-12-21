#!/bin/bash

# Configure password complexity
echo "Configuring password complexity..."

# Use minclass approach (require 4 character classes)
if grep -qi '^minclass\s*=' /etc/security/pwquality.conf 2>/dev/null; then
    sed -i 's/^minclass\s*=.*/minclass = 4/' /etc/security/pwquality.conf
elif grep -qi '^#\s*minclass\s*=' /etc/security/pwquality.conf 2>/dev/null; then
    sed -i 's/^#\s*minclass\s*=.*/minclass = 4/' /etc/security/pwquality.conf
else
    echo "minclass = 4" >> /etc/security/pwquality.conf
fi

echo "SUCCESS: minclass set to 4 (requires 4 character classes)"
