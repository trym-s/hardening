#!/bin/bash

# Enable password quality for root
echo "Enabling password quality for root..."

if ! grep -qi '^enforce_for_root' /etc/security/pwquality.conf 2>/dev/null; then
    echo "enforce_for_root" >> /etc/security/pwquality.conf
fi

echo "SUCCESS: Password quality enforced for root"
