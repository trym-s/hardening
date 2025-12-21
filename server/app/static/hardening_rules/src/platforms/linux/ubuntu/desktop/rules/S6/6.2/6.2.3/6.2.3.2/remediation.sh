#!/bin/bash

# 6.2.3.2 Ensure actions as another user are always logged (Automated)

echo "Adding audit rules for actions as another user..."

cat >> /etc/audit/rules.d/50-user_emulation.rules <<'EOF'
# Monitor actions as another user
-a always,exit -F arch=b64 -C euid!=uid -F auid!=unset -S execve -k user_emulation
-a always,exit -F arch=b32 -C euid!=uid -F auid!=unset -S execve -k user_emulation
EOF

# Load the new rules
augenrules --load

echo "Audit rules for actions as another user have been added"
