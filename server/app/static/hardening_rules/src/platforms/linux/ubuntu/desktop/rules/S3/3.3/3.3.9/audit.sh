#!/bin/bash
# CIS 3.3.9 Ensure suspicious packets are logged

echo "Checking suspicious packet logging..."

FAIL=0

for param in net.ipv4.conf.all.log_martians \
             net.ipv4.conf.default.log_martians; do
    VALUE=$(sysctl -n $param 2>/dev/null)
    if [ "$VALUE" = "1" ]; then
        echo "PASS: $param = 1"
    else
        echo "FAIL: $param = $VALUE (should be 1)"
        FAIL=1
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
