#!/bin/bash
# CIS 3.3.4 Ensure broadcast ICMP requests are ignored

echo "Checking broadcast ICMP request handling..."

VALUE=$(sysctl -n net.ipv4.icmp_echo_ignore_broadcasts 2>/dev/null)

if [ "$VALUE" = "1" ]; then
    echo "PASS: net.ipv4.icmp_echo_ignore_broadcasts = 1"
    echo ""
    echo "AUDIT RESULT: PASS"
    exit 0
else
    echo "FAIL: net.ipv4.icmp_echo_ignore_broadcasts = $VALUE (should be 1)"
    echo ""
    echo "AUDIT RESULT: FAIL"
    exit 1
fi
