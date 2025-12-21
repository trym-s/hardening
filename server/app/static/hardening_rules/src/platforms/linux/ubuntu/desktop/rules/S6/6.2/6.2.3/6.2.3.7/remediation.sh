#!/bin/bash

# 6.2.3.7 Ensure unsuccessful file access attempts are collected (Automated)

echo "Adding audit rules for unsuccessful file access attempts..."

cat >> /etc/audit/rules.d/50-access.rules <<'EOF'
# Monitor unsuccessful file access attempts
-a always,exit -F arch=b64 -S open,openat,openat2,open_by_handle_at -F exit=-EACCES -F auid>=1000 -F auid!=unset -k access
-a always,exit -F arch=b64 -S open,openat,openat2,open_by_handle_at -F exit=-EPERM -F auid>=1000 -F auid!=unset -k access
-a always,exit -F arch=b32 -S open,openat,openat2,open_by_handle_at -F exit=-EACCES -F auid>=1000 -F auid!=unset -k access
-a always,exit -F arch=b32 -S open,openat,openat2,open_by_handle_at -F exit=-EPERM -F auid>=1000 -F auid!=unset -k access
EOF

augenrules --load

echo "Audit rules for unsuccessful file access have been added"
