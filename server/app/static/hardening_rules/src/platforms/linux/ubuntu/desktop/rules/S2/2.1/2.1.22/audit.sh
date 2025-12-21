#!/bin/bash
# CIS Benchmark 2.1.22 - Ensure mail transfer agent is configured for local-only mode
audit_passed=true
echo "Checking mail transfer agent configuration..."

# Check if MTA is listening on non-localhost interfaces
non_local=$(ss -plntu | grep -E ':25\s' | grep -E -v '\s(127\.0\.0\.1|::1):25\s')

if [ -n "$non_local" ]; then
    echo "FAIL: MTA is listening on non-localhost interfaces"
    echo "$non_local"
    audit_passed=false
else
    echo "PASS: MTA is configured for local-only mode or not running"
fi

# Check postfix configuration if installed
if dpkg-query -W -f='${db:Status-Status}' postfix 2>/dev/null | grep -q "installed"; then
    if [ -f /etc/postfix/main.cf ]; then
        inet_interfaces=$(grep -E '^\s*inet_interfaces\s*=' /etc/postfix/main.cf 2>/dev/null)
        if echo "$inet_interfaces" | grep -qE 'loopback-only|localhost|127\.0\.0\.1'; then
            echo "PASS: postfix inet_interfaces is set to local-only"
        else
            echo "FAIL: postfix inet_interfaces is not set to local-only"
            echo "      Current setting: $inet_interfaces"
            audit_passed=false
        fi
    fi
fi

echo ""
[ "$audit_passed" = true ] && echo "AUDIT RESULT: PASS" && exit 0 || echo "AUDIT RESULT: FAIL" && exit 1
