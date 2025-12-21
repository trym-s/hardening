#!/bin/bash

# CIS 5.3.3.4.1 - Ensure pam_unix does not include nullok
# Remove nullok from pam_unix in common-password only
#
# WARNING: Do NOT remove nullok from common-auth!
# Removing nullok from common-auth can break authentication
# and lock users out of the system.

echo "Removing nullok from pam_unix in common-password..."

# Only remove nullok from common-password (for password changes)
# NOT from common-auth (for authentication)
sed -i 's/\s*nullok//g' /etc/pam.d/common-password

echo "SUCCESS: nullok removed from pam_unix in common-password"
echo "NOTE: common-auth was NOT modified to prevent authentication issues"
