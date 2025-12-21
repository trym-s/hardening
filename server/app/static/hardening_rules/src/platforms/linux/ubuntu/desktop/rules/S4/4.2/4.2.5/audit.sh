#!/bin/bash
# CIS 4.2.5 Ensure ufw outbound connections are configured

echo "Checking ufw outbound connection configuration..."

UFW_STATUS=$(ufw status verbose 2>/dev/null)

echo "Current UFW status:"
echo "$UFW_STATUS"
echo ""

# Check default outgoing policy
if echo "$UFW_STATUS" | grep -q "Default: .* (outgoing)"; then
    OUTGOING=$(echo "$UFW_STATUS" | grep "Default:" | sed 's/.*(\(.*\) (outgoing).*/\1/')
    echo "INFO: Default outgoing policy: $OUTGOING"
fi

echo ""
echo "AUDIT RESULT: MANUAL - Verify outbound rules match site policy"
exit 0
