#!/bin/bash

# Check if pam_faillock module is enabled
if grep -P -- '\bpam_faillock\.so\b' /etc/pam.d/common-auth &>/dev/null; then
    echo "PASS: pam_faillock module is enabled"
    grep -P -- '\bpam_faillock\.so\b' /etc/pam.d/common-{auth,account} 2>/dev/null
    exit 0
else
    echo "FAIL: pam_faillock module is not enabled"
    exit 1
fi
