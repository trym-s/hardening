#!/bin/bash
# CIS 3.3.10 Ensure TCP SYN cookies is enabled

echo "Checking TCP SYN cookies status..."

VALUE=$(sysctl -n net.ipv4.tcp_syncookies 2>/dev/null)

if [ "$VALUE" = "1" ]; then
    echo "PASS: net.ipv4.tcp_syncookies = 1"
    echo ""
    echo "AUDIT RESULT: PASS"
    exit 0
else
    echo "FAIL: net.ipv4.tcp_syncookies = $VALUE (should be 1)"
    echo ""
    echo "AUDIT RESULT: FAIL"
    exit 1
fi
