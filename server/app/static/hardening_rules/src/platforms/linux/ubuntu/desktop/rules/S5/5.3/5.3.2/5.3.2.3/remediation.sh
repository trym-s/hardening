#!/bin/bash

# Enable pam_pwquality module
echo "Enabling pam_pwquality module..."

# Check if already enabled
if grep -q 'pam_pwquality\.so' /etc/pam.d/common-password 2>/dev/null; then
    echo "INFO: pam_pwquality already enabled"
    grep pam_pwquality /etc/pam.d/common-password
    return 0
fi

# Try pam-auth-update first
echo "Trying pam-auth-update..."
if pam-auth-update --enable pwquality 2>/dev/null; then
    if grep -q 'pam_pwquality\.so' /etc/pam.d/common-password 2>/dev/null; then
        echo "SUCCESS: pam_pwquality module enabled via pam-auth-update"
        grep pam_pwquality /etc/pam.d/common-password
        return 0
    fi
fi

# Manual configuration if pam-auth-update failed
echo "pam-auth-update did not work, configuring manually..."

# Backup file
cp /etc/pam.d/common-password /etc/pam.d/common-password.bak.$(date +%s)

# Add pam_pwquality before pam_unix.so in common-password
# The line: password requisite pam_pwquality.so retry=3
sed -i '/pam_unix.so/i password    requisite                       pam_pwquality.so retry=3' /etc/pam.d/common-password

# Verify
if grep -q 'pam_pwquality\.so' /etc/pam.d/common-password; then
    echo "SUCCESS: pam_pwquality module configured"
    echo ""
    echo "Configuration in common-password:"
    grep pam_pwquality /etc/pam.d/common-password
else
    echo "FAIL: Could not configure pam_pwquality"
    return 1
fi
