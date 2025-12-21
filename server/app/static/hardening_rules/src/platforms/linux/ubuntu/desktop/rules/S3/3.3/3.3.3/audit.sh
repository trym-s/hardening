#!/bin/bash
# CIS 3.3.3 Ensure bogus ICMP responses are ignored

echo "Checking bogus ICMP response handling..."

VALUE=$(sysctl -n net.ipv4.icmp_ignore_bogus_error_responses 2>/dev/null)

if [ "$VALUE" = "1" ]; then
    echo "PASS: net.ipv4.icmp_ignore_bogus_error_responses = 1"
    echo ""
    echo "AUDIT RESULT: PASS"
    exit 0
else
    echo "FAIL: net.ipv4.icmp_ignore_bogus_error_responses = $VALUE (should be 1)"
    echo ""
    echo "AUDIT RESULT: FAIL"
    exit 1
fi
