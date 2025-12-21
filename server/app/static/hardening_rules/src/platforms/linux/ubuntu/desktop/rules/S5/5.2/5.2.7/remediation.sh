#!/bin/bash

# Restrict access to su command
echo "Restricting access to su command..."

# Create sugroup if it doesn't exist
if ! getent group sugroup &>/dev/null; then
    groupadd sugroup
    echo "Created sugroup"
fi

# Check if already configured correctly
if grep -Pi -- '^\h*auth\h+required\h+pam_wheel\.so\h+use_uid\h+group=' /etc/pam.d/su &>/dev/null; then
    echo "INFO: su access already restricted"
    grep -Pi -- '^\h*auth\h+\H+\h+pam_wheel\.so' /etc/pam.d/su
    return 0
fi

# Remove any existing pam_wheel.so line (commented or not)
sed -i '/pam_wheel\.so/d' /etc/pam.d/su

# Find the line number of pam_rootok.so
line_num=$(grep -n 'pam_rootok.so' /etc/pam.d/su | head -1 | cut -d: -f1)

if [ -n "$line_num" ]; then
    # Insert after pam_rootok.so
    sed -i "${line_num}a auth required pam_wheel.so use_uid group=sugroup" /etc/pam.d/su
else
    # If pam_rootok.so not found, add at the beginning of auth section
    sed -i '1i auth required pam_wheel.so use_uid group=sugroup' /etc/pam.d/su
fi

echo "SUCCESS: su command restricted to sugroup members"
echo "To allow a user to use su: usermod -aG sugroup <username>"
echo ""
echo "Current configuration:"
grep -i pam_wheel /etc/pam.d/su
