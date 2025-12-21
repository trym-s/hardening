#!/bin/bash

# Enable pam_unix module
echo "Enabling pam_unix module..."

# Check if already enabled
if grep -q 'pam_unix\.so' /etc/pam.d/common-password 2>/dev/null && \
   grep -q 'pam_unix\.so' /etc/pam.d/common-auth 2>/dev/null; then
    echo "INFO: pam_unix already enabled"
    grep pam_unix /etc/pam.d/common-{password,auth}
    return 0
fi

# Try pam-auth-update (this should work for unix)
echo "Enabling via pam-auth-update..."
if pam-auth-update --enable unix 2>/dev/null; then
    if grep -q 'pam_unix\.so' /etc/pam.d/common-password 2>/dev/null; then
        echo "SUCCESS: pam_unix module enabled"
        grep pam_unix /etc/pam.d/common-{password,auth}
        return 0
    fi
fi

echo "FAIL: Could not enable pam_unix module"
return 1
