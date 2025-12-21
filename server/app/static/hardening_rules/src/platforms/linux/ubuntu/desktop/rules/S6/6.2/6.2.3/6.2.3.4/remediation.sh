#!/bin/bash

# 6.2.3.4 Ensure events that modify date and time information are collected (Automated)

echo "Adding audit rules for date and time modifications..."

cat >> /etc/audit/rules.d/50-time-change.rules <<'EOF'
# Monitor date and time changes
-a always,exit -F arch=b64 -S adjtimex,settimeofday,clock_settime -k time-change
-a always,exit -F arch=b32 -S adjtimex,settimeofday,clock_settime -k time-change
-w /etc/localtime -p wa -k time-change
EOF

# Load the new rules
augenrules --load

echo "Audit rules for date and time modifications have been added"
