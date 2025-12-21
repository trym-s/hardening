#!/bin/bash
# CIS 3.3.11 Ensure IPv6 router advertisements are not accepted

echo "Checking IPv6 router advertisement acceptance..."

# Check if IPv6 is enabled
if ! sysctl net.ipv6.conf.all.accept_ra &>/dev/null; then
    echo "INFO: IPv6 is not enabled on this system"
    echo ""
    echo "AUDIT RESULT: PASS - Not applicable"
    exit 0
fi

FAIL=0

for param in net.ipv6.conf.all.accept_ra \
             net.ipv6.conf.default.accept_ra; do
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
