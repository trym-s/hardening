#!/bin/bash

# 6.2.3.10 Ensure successful file system mounts are collected (Automated)

echo "Adding audit rules for file system mounts..."

cat >> /etc/audit/rules.d/50-mounts.rules <<'EOF'
# Monitor file system mounts
-a always,exit -F arch=b64 -S mount -F auid>=1000 -F auid!=unset -k mounts
-a always,exit -F arch=b32 -S mount -F auid>=1000 -F auid!=unset -k mounts
EOF

augenrules --load

echo "Audit rules for file system mounts have been added"
