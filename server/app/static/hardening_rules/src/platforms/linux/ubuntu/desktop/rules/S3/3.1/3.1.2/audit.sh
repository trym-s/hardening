#!/bin/bash
# CIS 3.1.2 Ensure wireless interfaces are disabled

echo "Checking wireless interface status..."

FAIL=0

# Check if any wireless interfaces exist
WIRELESS_FOUND=$(find /sys/class/net/*/ -type d -name wireless 2>/dev/null)

if [ -n "$WIRELESS_FOUND" ]; then
    echo "WARNING: Wireless interfaces found:"
    echo "$WIRELESS_FOUND"
    
    # Check if wireless is blocked via rfkill
    if command -v rfkill &>/dev/null; then
        if rfkill list wifi 2>/dev/null | grep -q "Soft blocked: yes"; then
            echo "INFO: Wireless is soft blocked via rfkill"
        elif rfkill list wifi 2>/dev/null | grep -q "Hard blocked: yes"; then
            echo "INFO: Wireless is hard blocked"
        else
            echo "FAIL: Wireless interfaces exist and are not blocked"
            FAIL=1
        fi
    else
        echo "FAIL: Wireless interfaces exist and rfkill is not available"
        FAIL=1
    fi
else
    echo "PASS: No wireless interfaces found"
fi

# Check if any wireless modules are loaded
WIRELESS_MODULES=$(lsmod | grep -E "^(cfg80211|mac80211|iwlwifi|ath|rtl|brcm)" 2>/dev/null)
if [ -n "$WIRELESS_MODULES" ]; then
    echo "WARNING: Wireless kernel modules loaded:"
    echo "$WIRELESS_MODULES"
fi

if [ "$FAIL" -eq 0 ]; then
    echo ""
    echo "AUDIT RESULT: PASS"
    exit 0
else
    echo ""
    echo "AUDIT RESULT: FAIL"
    exit 1
fi
