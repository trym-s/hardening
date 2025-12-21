#!/bin/bash

# Check if pam_pwhistory module is enabled
if grep -P -- '\bpam_pwhistory\.so\b' /etc/pam.d/common-password &>/dev/null; then
    echo "PASS: pam_pwhistory module is enabled"
    grep -P -- '\bpam_pwhistory\.so\b' /etc/pam.d/common-password
    exit 0
else
    echo "FAIL: pam_pwhistory module is not enabled"
    exit 1
fi
