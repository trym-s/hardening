#!/bin/bash
# CIS 2.4.2.1 Ensure at is restricted to authorized users

echo "Applying remediation for CIS 2.4.2.1..."

# First check if at is installed
if ! dpkg -l | grep -q "^ii.*\bat\b"; then
    echo "INFO: at is not installed - no remediation needed"
    echo "Remediation complete for CIS 2.4.2.1"
    return 0
fi

# Remove at.deny if it exists
if [ -f /etc/at.deny ]; then
    rm -f /etc/at.deny
    echo "Removed /etc/at.deny"
else
    echo "/etc/at.deny does not exist - no removal needed"
fi

# Create at.allow if it doesn't exist
if [ ! -f /etc/at.allow ]; then
    touch /etc/at.allow
    echo "Created /etc/at.allow"
fi

# Set ownership and permissions on at.allow
chown root:root /etc/at.allow
chmod 640 /etc/at.allow
echo "/etc/at.allow permissions set to 640, owned by root:root"

# Add root to at.allow if not already present
if ! grep -q "^root$" /etc/at.allow 2>/dev/null; then
    echo "root" >> /etc/at.allow
    echo "Added root to /etc/at.allow"
fi

echo "Remediation complete for CIS 2.4.2.1"
echo "NOTE: Add other authorized users to /etc/at.allow as needed"
