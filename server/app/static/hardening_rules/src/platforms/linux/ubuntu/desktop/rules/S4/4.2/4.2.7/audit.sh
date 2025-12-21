#!/bin/bash
# CIS 4.2.7 Ensure ufw default deny firewall policy

echo "Checking ufw default policy..."

UFW_STATUS=$(ufw status verbose 2>/dev/null)

FAIL=0

# Check default incoming policy
if echo "$UFW_STATUS" | grep -q "Default: deny (incoming)"; then
    echo "PASS: Default incoming policy is deny"
else
    echo "FAIL: Default incoming policy is not deny"
    FAIL=1
fi

# Show current default policies
echo ""
echo "Current defaults:"
echo "$UFW_STATUS" | grep "Default:"

if [ "$FAIL" -eq 0 ]; then
    echo ""
    echo "AUDIT RESULT: PASS"
    exit 0
else
    echo ""
    echo "AUDIT RESULT: FAIL"
    exit 1
fi
