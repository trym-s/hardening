#!/bin/bash
# CIS 3.3.1 Ensure IP forwarding is disabled

echo "Checking IP forwarding status..."

FAIL=0

# Check IPv4 forwarding
IPV4_FWD=$(sysctl -n net.ipv4.ip_forward 2>/dev/null)
if [ "$IPV4_FWD" = "0" ]; then
    echo "PASS: net.ipv4.ip_forward = 0"
else
    echo "FAIL: net.ipv4.ip_forward = $IPV4_FWD (should be 0)"
    FAIL=1
fi

# Check IPv6 forwarding (if IPv6 is enabled)
IPV6_FWD=$(sysctl -n net.ipv6.conf.all.forwarding 2>/dev/null)
if [ -n "$IPV6_FWD" ]; then
    if [ "$IPV6_FWD" = "0" ]; then
        echo "PASS: net.ipv6.conf.all.forwarding = 0"
    else
        echo "FAIL: net.ipv6.conf.all.forwarding = $IPV6_FWD (should be 0)"
        FAIL=1
    fi
else
    echo "INFO: IPv6 not available, skipping IPv6 forwarding check"
fi

# Check persistent configuration
if grep -rqs "^\s*net\.ipv4\.ip_forward\s*=\s*1" /etc/sysctl.conf /etc/sysctl.d/; then
    echo "WARNING: IP forwarding may be enabled at boot via sysctl configuration"
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
