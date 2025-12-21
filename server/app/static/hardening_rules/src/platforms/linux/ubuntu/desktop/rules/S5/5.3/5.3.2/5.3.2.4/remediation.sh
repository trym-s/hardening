#!/bin/bash

# Enable pam_pwhistory module
echo "Enabling pam_pwhistory module..."

# Check if already enabled
if grep -q 'pam_pwhistory\.so' /etc/pam.d/common-password 2>/dev/null; then
    echo "INFO: pam_pwhistory already enabled"
    grep pam_pwhistory /etc/pam.d/common-password
    return 0
fi

# Manual configuration
echo "Configuring pam_pwhistory manually..."

# Backup file
cp /etc/pam.d/common-password /etc/pam.d/common-password.bak.$(date +%s)

# Add pam_pwhistory before pam_unix.so in common-password
# The line should be: password required pam_pwhistory.so remember=24 enforce_for_root
sed -i '/pam_unix.so/i password    required                        pam_pwhistory.so remember=24 enforce_for_root' /etc/pam.d/common-password

# Verify
if grep -q 'pam_pwhistory\.so' /etc/pam.d/common-password; then
    echo "SUCCESS: pam_pwhistory module configured"
    echo ""
    echo "Configuration in common-password:"
    grep pam_pwhistory /etc/pam.d/common-password
else
    echo "FAIL: Could not configure pam_pwhistory"
    return 1
fi
