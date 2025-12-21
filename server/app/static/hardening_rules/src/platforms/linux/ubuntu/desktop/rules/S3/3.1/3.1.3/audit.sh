#!/bin/bash
# CIS 3.1.3 Ensure bluetooth services are not in use

echo "Checking Bluetooth status..."

FAIL=0

# Check if bluetooth service exists and is enabled
if systemctl list-unit-files 2>/dev/null | grep -q "bluetooth.service"; then
    BT_STATUS=$(systemctl is-enabled bluetooth.service 2>/dev/null)
    if [ "$BT_STATUS" = "enabled" ]; then
        echo "FAIL: bluetooth.service is enabled"
        FAIL=1
    elif [ "$BT_STATUS" = "masked" ]; then
        echo "PASS: bluetooth.service is masked"
    elif [ "$BT_STATUS" = "disabled" ]; then
        echo "PASS: bluetooth.service is disabled"
    else
        echo "INFO: bluetooth.service status: $BT_STATUS"
    fi
    
    # Check if service is running
    if systemctl is-active bluetooth.service 2>/dev/null | grep -q "^active"; then
        echo "FAIL: bluetooth.service is running"
        FAIL=1
    else
        echo "PASS: bluetooth.service is not running"
    fi
else
    echo "PASS: bluetooth.service does not exist"
fi

# Check if bluez package is installed
if dpkg -l bluez 2>/dev/null | grep -q "^ii"; then
    echo "WARNING: bluez package is installed"
else
    echo "PASS: bluez package is not installed"
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
