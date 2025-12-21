#!/bin/bash

# CIS 5.3.3.4.1 - Ensure pam_unix does not include nullok
#
# NOTE: This check is only for common-password (password changes).
# common-auth should NOT be checked because removing nullok from it
# can cause authentication failures on some systems.

# Check if pam_unix includes nullok in common-password only
result=$(grep -Pi -- '^\h*[^#\n\r]+\h+pam_unix\.so\b.*\bnullok\b' /etc/pam.d/common-password 2>/dev/null)

if [ -z "$result" ]; then
    echo "PASS: pam_unix in common-password does not include nullok"
    exit 0
else
    echo "FAIL: pam_unix in common-password includes nullok"
    echo "$result"
    exit 1
fi
