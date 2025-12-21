#!/bin/bash

# 6.2.3.4 Ensure events that modify date and time information are collected (Automated)

echo "Checking if date and time modifications are collected..."

# Check for audit rules related to time changes
rules_found=$(auditctl -l 2>/dev/null | grep -E "adjtimex|settimeofday|clock_settime|/etc/localtime")

if echo "$rules_found" | grep -q "adjtimex" && \
   echo "$rules_found" | grep -q "settimeofday" && \
   echo "$rules_found" | grep -q "clock_settime" && \
   echo "$rules_found" | grep -q "/etc/localtime"; then
    echo "PASS: Date and time modifications are being audited"
    echo "$rules_found"
    exit 0
else
    echo "FAIL: Date and time modifications are not fully audited"
    echo "$rules_found"
    exit 1
fi
