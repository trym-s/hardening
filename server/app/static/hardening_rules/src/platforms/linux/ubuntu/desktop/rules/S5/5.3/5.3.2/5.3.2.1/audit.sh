#!/bin/bash

# Check if pam_unix module is enabled
if grep -P -- '\bpam_unix\.so\b' /etc/pam.d/common-{password,auth} &>/dev/null; then
    echo "PASS: pam_unix module is enabled"
    grep -P -- '\bpam_unix\.so\b' /etc/pam.d/common-{password,auth}
    exit 0
else
    echo "FAIL: pam_unix module is not enabled"
    exit 1
fi
