#!/bin/bash

# Configure use_authtok for pam_pwhistory
echo "Configuring use_authtok for pam_pwhistory..."

if [ ! -f /etc/security/pwhistory.conf ]; then
    touch /etc/security/pwhistory.conf
fi

if ! grep -qi '^use_authtok' /etc/security/pwhistory.conf 2>/dev/null; then
    echo "use_authtok" >> /etc/security/pwhistory.conf
fi

echo "SUCCESS: use_authtok configured for pam_pwhistory"
