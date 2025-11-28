#!/bin/bash
# 4.2.5 Ensure ufw outbound connections are configured

# This is a manual check as it depends on site policy.
# We check if there are any ALLOW OUT rules or if the default policy is ALLOW OUT.

if ufw status verbose | grep -q "Default:.*allow (outgoing)"; then
    echo "Default outgoing policy is allow"
    exit 0
elif ufw status verbose | grep -q "ALLOW OUT"; then
    echo "Outbound rules exist"
    exit 0
else
    echo "No outbound configuration detected"
    exit 1
fi
