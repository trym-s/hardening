#!/bin/bash
# CIS 3.3.8 Ensure source routed packets are not accepted

echo "Checking source route acceptance..."

FAIL=0

for param in net.ipv4.conf.all.accept_source_route \
             net.ipv4.conf.default.accept_source_route; do
    VALUE=$(sysctl -n $param 2>/dev/null)
    if [ "$VALUE" = "0" ]; then
        echo "PASS: $param = 0"
    else
        echo "FAIL: $param = $VALUE (should be 0)"
        FAIL=1
    fi
done

# Check IPv6 if available
for param in net.ipv6.conf.all.accept_source_route \
             net.ipv6.conf.default.accept_source_route; do
    VALUE=$(sysctl -n $param 2>/dev/null)
    if [ -n "$VALUE" ]; then
        if [ "$VALUE" = "0" ]; then
            echo "PASS: $param = 0"
        else
            echo "FAIL: $param = $VALUE (should be 0)"
            FAIL=1
        fi
    fi
done

if [ "$FAIL" -eq 0 ]; then
    echo ""
    echo "AUDIT RESULT: PASS"
    exit 0
else
    echo ""
    echo "AUDIT RESULT: FAIL"
    exit 1
fi
