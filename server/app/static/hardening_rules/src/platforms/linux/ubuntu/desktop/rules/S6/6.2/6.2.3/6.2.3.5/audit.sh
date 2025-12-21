#!/bin/bash

# 6.2.3.5 Ensure events that modify the system's network environment are collected (Automated)

echo "Checking if network environment modifications are collected..."

# Check for audit rules related to network changes
rules_found=$(auditctl -l 2>/dev/null | grep -E "sethostname|setdomainname|/etc/issue|/etc/issue.net|/etc/hosts|/etc/network|/etc/netplan")

if echo "$rules_found" | grep -q "sethostname" && \
   echo "$rules_found" | grep -q "setdomainname" && \
   echo "$rules_found" | grep -q "/etc/issue" && \
   echo "$rules_found" | grep -q "/etc/hosts"; then
    echo "PASS: Network environment modifications are being audited"
    echo "$rules_found"
    exit 0
else
    echo "FAIL: Network environment modifications are not fully audited"
    echo "$rules_found"
    exit 1
fi
