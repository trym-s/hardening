#!/bin/bash

# 6.2.3.8 Ensure events that modify user/group information are collected (Automated)

echo "Adding audit rules for user/group information modifications..."

cat >> /etc/audit/rules.d/50-identity.rules <<'EOF'
# Monitor user/group information changes
-w /etc/group -p wa -k identity
-w /etc/passwd -p wa -k identity
-w /etc/gshadow -p wa -k identity
-w /etc/shadow -p wa -k identity
-w /etc/security/opasswd -p wa -k identity
EOF

augenrules --load

echo "Audit rules for user/group information have been added"
