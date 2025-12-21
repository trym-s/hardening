#!/bin/bash
# CIS 3.3.6 Ensure secure ICMP redirects are not accepted

echo "Checking secure ICMP redirect acceptance..."

FAIL=0

for param in net.ipv4.conf.all.secure_redirects \
             net.ipv4.conf.default.secure_redirects; do
    VALUE=$(sysctl -n $param 2>/dev/null)
    if [ "$VALUE" = "0" ]; then
        echo "PASS: $param = 0"
    else
        echo "FAIL: $param = $VALUE (should be 0)"
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
