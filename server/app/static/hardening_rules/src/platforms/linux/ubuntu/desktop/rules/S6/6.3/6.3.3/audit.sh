#!/bin/bash
echo "Checking cryptographic integrity for audit tools..."
if grep -rE "^/usr/sbin/(auditctl|auditd|ausearch|aureport|autrace|augenrules)" /etc/aide/aide.conf* 2>/dev/null; then
    echo "PASS: Audit tools are protected by AIDE"
    exit 0
else
    echo "FAIL: Audit tools are not configured in AIDE"
    exit 1
fi
