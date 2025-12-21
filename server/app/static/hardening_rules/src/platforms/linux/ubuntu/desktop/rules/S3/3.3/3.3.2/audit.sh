#!/bin/bash
# CIS 3.3.2 Ensure packet redirect sending is disabled

echo "Checking packet redirect sending status..."

FAIL=0

ALL_SEND=$(sysctl -n net.ipv4.conf.all.send_redirects 2>/dev/null)
DEFAULT_SEND=$(sysctl -n net.ipv4.conf.default.send_redirects 2>/dev/null)

if [ "$ALL_SEND" = "0" ]; then
    echo "PASS: net.ipv4.conf.all.send_redirects = 0"
else
    echo "FAIL: net.ipv4.conf.all.send_redirects = $ALL_SEND (should be 0)"
    FAIL=1
fi

if [ "$DEFAULT_SEND" = "0" ]; then
    echo "PASS: net.ipv4.conf.default.send_redirects = 0"
else
    echo "FAIL: net.ipv4.conf.default.send_redirects = $DEFAULT_SEND (should be 0)"
    FAIL=1
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
