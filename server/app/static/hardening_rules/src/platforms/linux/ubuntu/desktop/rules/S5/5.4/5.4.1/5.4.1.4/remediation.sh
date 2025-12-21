#!/bin/bash

# CIS 5.4.1.4 - Ensure strong password hashing algorithm is configured
# Set ENCRYPT_METHOD to YESCRYPT

ENCRYPT_METHOD="YESCRYPT"

echo "Setting password hashing algorithm to $ENCRYPT_METHOD..."

# Update /etc/login.defs
if grep -q '^ENCRYPT_METHOD' /etc/login.defs; then
    sed -i "s/^ENCRYPT_METHOD.*/ENCRYPT_METHOD $ENCRYPT_METHOD/" /etc/login.defs
else
    echo "ENCRYPT_METHOD $ENCRYPT_METHOD" >> /etc/login.defs
fi

echo "SUCCESS: Password hashing algorithm set to $ENCRYPT_METHOD"
echo "NOTE: Existing passwords will use the old algorithm until changed."
echo "NOTE: This setting should be consistent with PAM configuration."
