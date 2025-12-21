#!/bin/bash

# Check if pam_pwquality module is enabled
if grep -P -- '\bpam_pwquality\.so\b' /etc/pam.d/common-password &>/dev/null; then
    echo "PASS: pam_pwquality module is enabled"
    grep -P -- '\bpam_pwquality\.so\b' /etc/pam.d/common-password
    exit 0
else
    echo "FAIL: pam_pwquality module is not enabled"
    exit 1
fi
