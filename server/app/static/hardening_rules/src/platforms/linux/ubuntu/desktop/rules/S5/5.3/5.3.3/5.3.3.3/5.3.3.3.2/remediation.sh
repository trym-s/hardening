#!/bin/bash

# Enable password history for root
echo "Enabling password history for root..."

if [ ! -f /etc/security/pwhistory.conf ]; then
    touch /etc/security/pwhistory.conf
fi

if ! grep -qi '^enforce_for_root' /etc/security/pwhistory.conf 2>/dev/null; then
    echo "enforce_for_root" >> /etc/security/pwhistory.conf
fi

echo "SUCCESS: Password history enforced for root"
